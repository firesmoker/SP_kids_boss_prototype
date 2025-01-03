extends Node2D
var parent: Node
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
	game = NodeHelper.get_root_game(self)
	if game:
		x_hide_position = game.detector_position_x
	else:
		print("kakaka")
	

func flash(color: Color = flash_color, time: float = flash_time) -> void:
	parent.modulate = color
	flash_time = time
	timer.wait_time = flash_time
	timer.start()
	await timer.timeout
	parent.modulate = starting_color
