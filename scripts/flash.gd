extends Node2D
var parent: Node2D
@export var x_hide_position: float = -450
@export var flash_color: Color = Color.WHITE
@export var flash_time: float = 0.1
var game: Node
var starting_color: Color
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = flash_time
	parent = get_parent()
	starting_color = parent.modulate
	game = get_tree().root.get_child(0)
	if game:
		x_hide_position = game.detector_position_x
	else:
		print("kakaka")
	

func flash(color: Color = flash_color) -> void:
	parent.modulate = color
	timer.start()
	await timer.timeout
	parent.modulate = starting_color
