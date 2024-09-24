class_name NotesContainer extends Sprite2D

@onready var ending_point: Node2D = $".."

@export var note_template: PackedScene
@export var rest_template: PackedScene

var starting_position_x: float
var size: float
var game: Game

var level_length_in_bars: float = 58
var bar_length_in_pixels: float

signal level_ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture.size.x = texture.size.x * level_length_in_bars
	size = texture.size.x
	bar_length_in_pixels = size / level_length_in_bars
	print("NEW SIZE IS " + str(size))
	game = get_tree().get_root().get_node("Game")
	level_ready.connect(game.on_level_ready)
	starting_position_x = size / 2
	set_parent_at_ending()
	populate()
	

func populate() -> void:
	var count: int = 0
	for x_position in range(0,size,bar_length_in_pixels / 4):
		count += 1
		var new_note: Node2D
		if count == 4:
			count = 0
			new_note = rest_template.instantiate()
		else:
			new_note = note_template.instantiate()
		add_child(new_note)
		new_note.position.x = x_position - size / 2
		print(new_note)
	


func set_parent_at_ending() -> void:
	position.x -= size / 2
	emit_signal("level_ready")

func get_size() -> float:
	#print("size is " + str(size))
	return size

func _process(delta: float) -> void:
	pass
