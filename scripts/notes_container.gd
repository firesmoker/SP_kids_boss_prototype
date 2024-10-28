class_name NotesContainer extends Sprite2D

@onready var ending_point: Node2D = $".."

@export_category("General")
@export var note_heigth: float = 12.0
@export var on_display_duration: float = 2
@export var barline_offset: float = 25
@export var treble_to_bass_gap: float = 200.5
@export var resolution_y_offset: float = 0
@export_category("Packed Scenes")
@export var note_template: PackedScene
@export var rest_template: PackedScene
@export var collectable_template: PackedScene
@export var collectable_marker_template: PackedScene
@export var barline_template: PackedScene
@export var finger_number_template: PackedScene

var notes_in_level: int = 0
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
	"rest": 13.5,
}
var starting_position_x: float
var size: float

var level_length_in_bars: float = 58
var bar_length_in_pixels: float
var left_edge_position: float = 0
var example_note_dict: Dictionary


func construct_level(ui_type: String = "both", melody_events: Array = [], bottom_melody_events: Array = [], display_duration: float = on_display_duration) -> void:
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

		elif event.type == "collectible" and Game.game_mode == "boss":
			if event.note.is_empty():
				var collectible_marker: CollectibleMarker = collectable_marker_template.instantiate()
				collectible_marker.event = event
				collectible_marker.position.x = event.time * bar_length_in_pixels - size / 2
				add_child(collectible_marker)
				continue
				
			var notes: Array = split_notes(event.note)
			for note: String in notes:
				var collectible: Collectible = collectable_template.instantiate()
				collectible.event = event
				collectible.note = note
				add_child(collectible)
				collectible.set_sprite(event.subtype)
				collectible.position.x = event.time * bar_length_in_pixels - size / 2
				collectible.position.y = note_heigth_by_pitch[event.note] + resolution_y_offset
				if bottom_staff:
					collectible.position.y += treble_to_bass_gap - bass_clef_offset
					collectible.stem.rotation = deg_to_rad(180)
					
				if event.details.has("finger") and notes[0] == note:
					var new_finger: Label = finger_number_template.instantiate()
					collectible.add_child(new_finger)
					new_finger.position.y = -800 + (note_heigth_by_pitch["D4"] - note_heigth_by_pitch[event.note]) * 5 + 120
					new_finger.text = event.details["finger"]
					if bottom_staff:
						new_finger.position.y += treble_to_bass_gap + 600 - 120
						
		elif event.type == "note" or event.type == "collectible":
			notes_in_level += 1
			var notes: Array = split_notes(event.note)
			for note: String in notes:
				var new_note: Note = note_template.instantiate()
				new_note.note = note
				new_note.event = event
				add_child(new_note)
				new_note.set_duration_visual(event.duration)
				new_note.position.x = event.time * bar_length_in_pixels - size / 2
				new_note.position.y = note_heigth_by_pitch[note] + resolution_y_offset
				if bottom_staff:
					new_note.position.y += treble_to_bass_gap - bass_clef_offset
					new_note.stem.rotation = deg_to_rad(180)
				if event.details.has("finger") and notes[0] == note:
					var new_finger: Label = finger_number_template.instantiate()
					new_note.add_child(new_finger)
					new_finger.position.y = -800 + (note_heigth_by_pitch["D4"] - note_heigth_by_pitch[note]) * 5 + 120
					new_finger.text = event.details["finger"]
					if bottom_staff:
						new_finger.position.y += treble_to_bass_gap + 600 - 120
		

	

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
