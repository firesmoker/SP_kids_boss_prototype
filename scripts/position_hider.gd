extends Node2D
var parent: Node2D
@export var hide_left: bool = true
@export var true_hide_right: bool = false
@export var x_hide_position: float = -450
@export var x_hide_position_right: float = 380
var game: Node
var starting_alpha: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	starting_alpha = parent.modulate.a
	game = get_tree().root.get_child(0)
	if game:
		x_hide_position = game.detector_position_x
	else:
		print("kakaka")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parent.global_position.x < x_hide_position -150 and hide_left:
		parent.modulate.a -= 0.02
	elif parent.global_position.x > x_hide_position and parent.modulate.a < starting_alpha:
		parent.modulate.a += 0.05
		
	if parent.global_position.x > x_hide_position_right and true_hide_right:
		parent.visible = false
	else:
		parent.visible = true
