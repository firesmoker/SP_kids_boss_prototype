class_name NotesContainer extends Sprite2D

@onready var ending_point: Node2D = $".."

@export_category("General")
@export var note_heigth: float = 12.0
@export var on_display_duration: float = 2
@export_category("Packed Scenes")
@export var note_template: PackedScene
@export var rest_template: PackedScene
@export var bomb_template: PackedScene
@export var barline_template: PackedScene

@export var barline_offset: float = 25
@export var treble_to_bass_gap: float = 200.5
@export var resolution_y_offset: float = 0

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
	"A4": 30,
	"B4": 18,
	"rest": 30,
}
var starting_position_x: float
var size: float

var level_length_in_bars: float = 58
var bar_length_in_pixels: float
var left_edge_position: float = 0
var example_note_dict: Dictionary


func construct_level(with_melody_events: bool = false, melody_events: Array = [], bottom_melody_events: Array = []) -> void:
	if with_melody_events:
		level_length_in_bars = get_level_length_from_melody_event(melody_events)
		set_level_size()
		create_bar_lines(true)
		set_parent_at_ending()
		populate_from_melody_events(melody_events)
		if bottom_melody_events.size() > 0:
			populate_from_melody_events(bottom_melody_events, true)
	else:
		set_level_size()
		create_bar_lines()
		set_parent_at_ending()
		populate()

func create_bar_lines(two_staves: bool = false) -> void:
	print("CREATING BAR LINESSSS")
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


func set_level_size() -> void:
	texture.size.x = texture.size.x * level_length_in_bars / on_display_duration
	size = texture.size.x
	bar_length_in_pixels = size / level_length_in_bars
	starting_position_x = size / 2
	left_edge_position = -size / 2

func populate_from_melody_events(melody_events: Array, bottom_staff: bool = false) -> void:
	for event: MelodyEvent in melody_events:
		if event.type == "rest":
			var new_note: Note = rest_template.instantiate()
			new_note.event = event
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
		elif event.type == "note":
			var new_note: Note = note_template.instantiate()
			new_note.event = event
			add_child(new_note)
			new_note.position.x = event.time * bar_length_in_pixels - size / 2
			new_note.set_duration_visual(event.duration)
			new_note.position.y = note_heigth_by_pitch[event.note] + resolution_y_offset
			if bottom_staff:
				new_note.position.y += treble_to_bass_gap - bass_clef_offset
				new_note.stem.rotation = deg_to_rad(180)
		elif event.type == "collectible":
			if event.subtype == "bomb":
				var collectible: Bomb = bomb_template.instantiate()
				collectible.event = event
				add_child(collectible)
				collectible.position.x = event.time * bar_length_in_pixels - size / 2
				collectible.position.y = note_heigth_by_pitch[event.note]
				if bottom_staff:
					collectible.position.y += 265
func populate() -> void:
	## TEMPORARY DICT GENERATION
	var absolute_rhythmic_position: float = 0
	for i in range(100):
		example_note_dict[i] = {
			"pitch" = "G4",
			"rhythmic_position" = absolute_rhythmic_position
		}
		absolute_rhythmic_position += 0.25
	
	## Build level from dictionary
	var count: int = 0
	for key: int in example_note_dict:
		count += 1
		var rest: bool = false
		var new_note: Note = note_template.instantiate()
		if count == 4:
			count = 0
			rest = true
			new_note = rest_template.instantiate()
		else:
			new_note = note_template.instantiate()
		add_child(new_note)
		new_note.position.x = example_note_dict[key]["rhythmic_position"] * bar_length_in_pixels - size / 2
		new_note.pitch = example_note_dict[key]["pitch"]
		if not rest:
			new_note.position.y = note_heigth_by_pitch[example_note_dict[key]["pitch"]]
		else:
			new_note.position.y = note_heigth_by_pitch["G4"]
	

func set_parent_at_ending() -> void:
	position.x -= size / 2

func get_size() -> float:
	return size
