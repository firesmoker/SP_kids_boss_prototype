class_name Expander extends Node2D
var parent: Node
var game: Node
@onready var debug: Label = $Debug

var expanding: bool = false
var reverse_expanding: bool = false
var target_scale_modifier: float = 3
var expand_progress: float = 0
var original_scale: Vector2
var target_scale: Vector2
var time_to_scale: float = 0.4

var original_position: Vector2
var target_position: Vector2 = Vector2(0,0)
var speed: float = 1
var moving: bool = false
var reverse_moving: bool = false
var moving_progress: float = 0
var time_to_move: float = 0.3

var teleport_progress: float = 0
var teleport_finished: bool = true
var teleporting: bool = true
var time_to_teleport_back: float = 0.5

var finished_reverse_moving: bool = true

func _ready() -> void:
	parent = get_parent()
	game = NodeHelper.get_root_game(self)
	original_scale = parent.scale
	target_scale = original_scale * target_scale_modifier
	original_position = parent.global_position
	

func _process(delta: float) -> void:
	debug.text = "moving_progress: " + str(moving_progress)
	
	if expanding:
		expand_progress += delta
		if expand_progress >= time_to_scale:
			expand_progress = time_to_scale
			expanding = false
		parent.scale = lerp(original_scale, target_scale, expand_progress / time_to_scale)
		if expand_progress >= time_to_scale:
			expand_progress = 0
	elif reverse_expanding:
		expand_progress += delta
		if expand_progress >= time_to_scale:
			expand_progress = time_to_scale
			expanding = false
			reverse_expanding = false
		parent.scale = lerp(target_scale, original_scale, expand_progress / time_to_scale)
	
	if moving:
		finished_reverse_moving = false
		moving_progress += delta
		if moving_progress >= time_to_move:
			moving_progress = time_to_move
			parent.global_position = lerp(original_position, target_position, moving_progress / time_to_move)
			moving = false
			moving_progress = 0
		else:
			parent.global_position = lerp(original_position, target_position, moving_progress / time_to_move)
	elif reverse_moving and not finished_reverse_moving:
		moving_progress += delta
		if moving_progress >= time_to_move:
			moving_progress = time_to_move
			parent.global_position = lerp(target_position, original_position, moving_progress / time_to_move)
			reverse_moving = false
			moving_progress = 0
			finished_reverse_moving = true
		else:
			parent.global_position = lerp(target_position, original_position, moving_progress / time_to_move)

func expand(modifier: float = target_scale_modifier, time: float = time_to_scale, reverse: bool = false, x_scale: float = 1) -> void:
	expanding = true
	parent.scale = original_scale 
	target_scale_modifier = modifier
	target_scale = original_scale * target_scale_modifier
	target_scale.x *= x_scale
	time_to_scale = time
	reverse_expanding = reverse

func move(new_position: Vector2, time: float = time_to_move, reverse: bool = false, generate_original_position: bool = true) -> void:
	moving_progress = 0
	if generate_original_position:
		original_position = parent.global_position
	moving = true
	time_to_move = time
	target_position = new_position
	reverse_moving = reverse

func teleport_and_return(new_position: Vector2, time_to_get_back: float = time_to_teleport_back) -> void:
	if teleport_finished:
		teleport_progress = 0
		teleporting = true
		parent.global_position = new_position
		time_to_teleport_back = time_to_get_back
		
		
