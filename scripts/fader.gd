extends Node2D
var parent: Node2D
var game: Node
@onready var timer: Timer = $Timer
var fading_in: bool = false
var fading_out: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	game = get_tree().root.get_child(0)

func _process(delta: float) -> void:
	if fading_in:
		parent.modulate.a += 0.02
		if parent.modulate.a >= 1:
			parent.modulate.a = 1
			fading_in = false
	elif fading_out:
		parent.modulate.a -= 0.02
		if parent.modulate.a <= 0:
			parent.modulate.a = 0
			fading_out = false

func fade_in() -> void:
	fading_out = false
	fading_in = true

func fade_out() -> void:
	fading_in = false
	fading_out = true
