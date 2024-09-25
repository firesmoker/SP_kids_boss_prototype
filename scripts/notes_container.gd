class_name NotesContainer extends Sprite2D

@onready var ending_point: Node2D = $".."

@export_category("General")
@export var note_heigth: float = 15.0
@export var on_display_duration: float = 2
@export_category("Packed Scenes")
@export var note_template: PackedScene
@export var rest_template: PackedScene

static var note_heigth_by_pitch: Dictionary = {
	"C4": 90,
	"D4": 75,
	"E4": 60,
	"F4": 45,
	"G4": 30,
	"A4": 15,
	"B4": 0,
	"rest": 30,
}
var starting_position_x: float
var size: float

var level_length_in_bars: float = 58
var bar_length_in_pixels: float

var example_note_dict: Dictionary


func construct_level(with_melody_events: bool = false, melody_events: Array = []) -> void:
	if with_melody_events:
		level_length_in_bars = get_level_length_from_melody_event(melody_events)
		set_level_size()
		set_parent_at_ending()
		populate_from_melody_events(melody_events)
	else:
		set_level_size()
		set_parent_at_ending()
		populate()

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

func populate_from_melody_events(melody_events: Array) -> void:
	for event: MelodyEvent in melody_events:
		var pitch: String = event.note.strip_edges()
		if pitch == "rest":
			var new_note: Note = rest_template.instantiate()
			add_child(new_note)
			new_note.set_duration_visual(event.duration)
			new_note.position.x = event.time * bar_length_in_pixels - size / 2
			new_note.position.y = note_heigth_by_pitch["F4"]
		elif pitch != "":
			var new_note: Note = note_template.instantiate()
			add_child(new_note)
			new_note.position.x = event.time * bar_length_in_pixels - size / 2
			new_note.pitch = pitch
			new_note.set_duration_visual(event.duration)
			new_note.position.y = note_heigth_by_pitch[event.note]

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
