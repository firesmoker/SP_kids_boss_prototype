extends Node2D
var parent: Node
var game: Node
var fading_in: bool = false
var fading_out: bool = false
var fade_interval: float = 0.02
var expand_fading: bool = false

var expand_fade_duration: float = 0.25
var target_scale: Vector2 = Vector2(1.25, 1.25)
var original_scale: Vector2

func _ready() -> void:
	parent = get_parent()
	game = get_tree().root.get_child(0)
	original_scale = parent.scale

func _process(delta: float) -> void:
	if fading_in:
		parent.modulate.a += fade_interval
		if parent.modulate.a >= 1:
			parent.modulate.a = 1
			fading_in = false
	elif fading_out:
		parent.modulate.a -= fade_interval
		if parent.modulate.a <= 0:
			parent.modulate.a = 0
			fading_out = false
	
	if expand_fading:
		var fade_amount: float = (delta / expand_fade_duration)
		parent.modulate.a -= fade_amount
		parent.scale.x = lerp(original_scale.x, target_scale.x, 1.0 - (parent.modulate.a / 1.0))
		parent.scale.y = lerp(original_scale.y, target_scale.y, 1.0 - (parent.modulate.a / 1.0))

		if parent.modulate.a <= 0:
			parent.modulate.a = 0
			expand_fading = false

func fade_in(fade_amount: float = fade_interval) -> void:
	fade_interval = fade_amount
	fading_out = false
	fading_in = true

func fade_out(fade_amount: float = fade_interval) -> void:
	fade_interval = fade_amount
	fading_in = false
	fading_out = true


func expand_fade_out(duration: float = expand_fade_duration) -> void:
	expand_fading = true  
	scale = original_scale 
	modulate.a = 1.0
	expand_fade_duration = duration
