class_name NotesContainer extends Sprite2D

@onready var ending_point: Node2D = $".."

@export_category("General")
@export var note_heigth: float = 15.0
@export_category("Packed Scenes")
@export var note_template: PackedScene
@export var rest_template: PackedScene

var note_heigth_by_pitch: Dictionary = {
	"C4": 90,
	"D4": 75,
	"E4": 60,
	"F4": 45,
	"G4": 30,
	"A4": 15,
	"B4": 0,
}
var starting_position_x: float
var size: float
var game: Game

var level_length_in_bars: float = 58
var bar_length_in_pixels: float

var example_note_dict: Dictionary


func _ready() -> void:
	texture.size.x = texture.size.x * level_length_in_bars
	size = texture.size.x
	bar_length_in_pixels = size / level_length_in_bars
	game = get_tree().get_root().get_node("Game")
	starting_position_x = size / 2
	set_parent_at_ending()
	populate()
	

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
