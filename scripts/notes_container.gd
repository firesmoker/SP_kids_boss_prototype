class_name NotesContainer extends Sprite2D

@onready var ending_point: Node2D = $".."

@export_category("General")
@export var note_heigth: float = 12.0
@export var on_display_duration: float = 2
@export var barline_offset: float = 25
@export var treble_to_bass_gap: float = 176.5
@export var resolution_y_offset: float = 0
@export_category("Packed Scenes")
@export var note_template: PackedScene
@export var rest_template: PackedScene
@export var collectable_template: PackedScene
@export var collectable_marker_template: PackedScene
@export var barline_template: PackedScene
@export var finger_number_template: PackedScene

static var golden_notes_in_level: int = 0
var notes_in_level: int = 0
var notes_value_in_level: int = 0
var bass_clef_offset: float = note_heigth * 12
static var note_heigth_by_pitch: Dictionary = {
	"C3": 181.5,
	"D3": 169.5,
	"E3": 157.5,
	"F3": 145.5,
	"G3": 133.5,
	"A3": 121.5,
	"B3": 109.5,
	"C4": 97.5,
	"D4": 85.5,
	"E4": 73.5,
	"F4": 61.5,
	"G4": 49.5,
	"A4": 37.5,
	"B4": 25.5,
	"C5": 13.5,
	"rest": 13.5,
}
var starting_position_x: float
var size: float

var level_length_in_bars: float = 58
var bar_length_in_pixels: float
var left_edge_position: float = 0
var example_note_dict: Dictionary


func construct_level(ui_type: String = "both", melody_events: Array = [], bottom_melody_events: Array = [], display_duration: float = on_display_duration) -> void:
	golden_notes_in_level = 0
	level_length_in_bars = get_level_length_from_melody_event(melody_events)
	set_level_size(display_duration)
	set_parent_at_ending()
	populate_from_melody_events(melody_events)
	if ui_type == "both" or ui_type == "bass":
		create_bar_lines(true)
		if bottom_melody_events.size() > 0:
			populate_from_melody_events(bottom_melody_events, true)
	else:
		create_bar_lines(false)
	Game.construction_complete = true


func create_bar_lines(two_staves: bool = false) -> void:
	for i: int in range(level_length_in_bars + 2):
		var new_barline: Node2D = barline_template.instantiate()
		add_child(new_barline)
		new_barline.position.x = left_edge_position + (i - 1) * bar_length_in_pixels - barline_offset
		if i == level_length_in_bars + 1:
			new_barline.scale.x *= 3
		new_barline.position.y = note_heigth * 2
		if two_staves:
			var new_bottom_barline: Node2D = barline_template.instantiate()
			add_child(new_bottom_barline)
			new_bottom_barline.position.x = left_edge_position + (i - 1) * bar_length_in_pixels - barline_offset
			new_bottom_barline.position.y += note_heigth * 2 + treble_to_bass_gap
			if i == level_length_in_bars + 1:
				new_bottom_barline.scale.x *= 3

func get_level_length_from_melody_event(melody_events: Array = []) -> float:
	var duration_sum: float = 0.0
	for event: MelodyEvent in melody_events:
		duration_sum += event.duration
	return duration_sum


func set_level_size(level_display_duration: float = on_display_duration) -> void:
	texture.size.x = texture.size.x * level_length_in_bars / level_display_duration
	size = texture.size.x
	bar_length_in_pixels = size / level_length_in_bars
	starting_position_x = size / 2
	left_edge_position = -size / 2


func add_fingers_to_note(note_node: Node2D, event: MelodyEvent, note: String, index: int, bottom_staff: bool) -> void:
	# Check if `event.details` has "finger" and process it
	if event.details.has("finger"):
		var fingers: PackedStringArray = str(event.details["finger"]).split("")
		fingers.reverse()

		if index < fingers.size():
			var finger: String = fingers[index]
			if finger:
				var base_y: float = -800 + (note_heigth_by_pitch["D4"] - note_heigth_by_pitch[note]) * 5 + 120
				var vertical_spacing: float = 130  # Adjust spacing between each finger label as needed

				var new_finger: Label = finger_number_template.instantiate()
				note_node.add_child(new_finger)

				# Adjust Y position based on whether it's the top or bottom staff
				if bottom_staff:
					new_finger.position.y = base_y + index * vertical_spacing + 1450  # Place each below the last for bottom staff
				else:
					new_finger.position.y = base_y - (fingers.size() - index - 1) * vertical_spacing  # Place each above the last for top staff

				if event.details.has("bold_fingering") and event.details["bold_fingering"]:
					var fv: FontVariation = FontVariation.new()
					fv.variation_embolden = 1
					new_finger.add_theme_font_override("font", fv)
					new_finger.add_theme_font_size_override("font_size", 36)
					
				new_finger.text = finger  # Set the finger number text


func populate_from_melody_events(melody_events: Array, bottom_staff: bool = false) -> void:
	for event: MelodyEvent in melody_events:
		print(event.as_string())
		if event.type == "rest":
			var new_note: Note = rest_template.instantiate()
			new_note.note = event.note
			add_child(new_note)
			new_note.set_duration_visual(event.duration)
			if event.duration == 1.0:
				new_note.position.x = event.time * bar_length_in_pixels - size / 2 + bar_length_in_pixels / 2 - barline_offset
			elif event.duration == 0.5:
				new_note.position.x = event.time * bar_length_in_pixels - size / 2 + bar_length_in_pixels / 8
			else:
				new_note.position.x = event.time * bar_length_in_pixels - size / 2
			new_note.position.y = note_heigth_by_pitch["F4"]
			if bottom_staff:
				new_note.position.y += treble_to_bass_gap

		elif event.type == "collectible" and not Game.sp_mode:
			if event.note.is_empty():
				var collectible_marker: CollectibleMarker = collectable_marker_template.instantiate()
				collectible_marker.event = event
				collectible_marker.position.x = event.time * bar_length_in_pixels - size / 2
				add_child(collectible_marker)
				continue

			var notes: Array = split_notes(event.note)
			for i in range(notes.size()):
				var note: String = notes[i]
				var collectible: Collectible = collectable_template.instantiate()
				collectible.event = event
				collectible.note = note
				add_child(collectible)
				if event.note == "B4" or event.note == "C5":
					collectible.stem.rotation = deg_to_rad(180)
				if bottom_staff:
					collectible.position.y += treble_to_bass_gap - bass_clef_offset
					collectible.stem.rotation = deg_to_rad(180)
				collectible.set_sprite(event.subtype)
				collectible.position.x = event.time * bar_length_in_pixels - size / 2
				collectible.position.y = note_heigth_by_pitch[event.note] + resolution_y_offset

				# Use add_fingers_to_note for finger positioning
				add_fingers_to_note(collectible, event, note, i, bottom_staff)
				if event.subtype == "golden_note":
					golden_notes_in_level += 1
					notes_in_level += 1
					notes_value_in_level += Game.golden_note_value

		elif event.type == "note" or event.subtype == "golden_note":
			var notes: Array = split_notes(event.note)
			for i in range(notes.size()):
				var note: String = notes[i]

				if event.details.has("action"):
					if event.details["action"] != "end":
						notes_in_level += 1
						notes_value_in_level += 1
				else:
					notes_in_level += 1
					notes_value_in_level += 1

				var new_note: Note = note_template.instantiate()
				new_note.note = note
				new_note.event = event
				add_child(new_note)
				new_note.set_duration_visual(event.duration)
				new_note.position.x = event.time * bar_length_in_pixels - size / 2
				new_note.position.y = note_heigth_by_pitch[note] + resolution_y_offset
				
				if event.note == "B4" or event.note == "C5":
					new_note.stem.rotation = deg_to_rad(180)

				if bottom_staff:
					new_note.position.y += treble_to_bass_gap - bass_clef_offset
					new_note.stem.rotation = deg_to_rad(180)

				# Use add_fingers_to_note for finger positioning
				add_fingers_to_note(new_note, event, note, i, bottom_staff)
	

func set_parent_at_ending() -> void:
	position.x -= size / 2

func get_size() -> float:
	return size
	

func split_notes(input_string: String) -> Array[String]:
	var regex: RegEx = RegEx.new()
	regex.compile(r"([A-G]#?\d)")  # Matches A-G, optional #, followed by a digit
	
	var notes: Array[String] = []
	var note_match: RegExMatch = regex.search(input_string)
	
	while note_match != null:  # Explicit check for match not being null
		notes.append(note_match.get_string())
		note_match = regex.search(input_string, note_match.get_end(0))  # Continue searching after the last match
	
	return notes
