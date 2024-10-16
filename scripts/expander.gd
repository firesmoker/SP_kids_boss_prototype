extends Node2D
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
var moving_progress: float = 0
var time_to_move: float = 0.3

func _ready() -> void:
	parent = get_parent()
	game = get_tree().root.get_child(0)
	original_scale = parent.scale
	target_scale = original_scale * target_scale_modifier
	

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
		moving_progress += delta
		if moving_progress >= time_to_move:
			moving_progress = time_to_move
			moving = false
		parent.global_position = lerp(original_position, target_position, moving_progress / time_to_move)

func expand(modifier: float = target_scale_modifier, time: float = time_to_scale, reverse: bool = false) -> void:
	expanding = true
	parent.scale = original_scale 
	target_scale_modifier = modifier
	target_scale = original_scale * target_scale_modifier
	time_to_scale = time
	reverse_expanding = reverse

func move(new_position: Vector2, time: float = time_to_move) -> void:
	moving_progress = 0
	original_position = parent.global_position
	moving = true
	time_to_move = time
	target_position = new_position
