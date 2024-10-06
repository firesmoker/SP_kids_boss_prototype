class_name Collectible extends AnimatableBody2D

@export_enum("Active", "Inactive") var state: String = "Active"
@export var event: MelodyEvent
@onready var helper_line: Sprite2D = $HelperLine
var effect: String = "slow_down"
@onready var heart: AnimatedSprite2D = $Heart
@onready var bomb: AnimatedSprite2D = $Bomb
@onready var slowdown: AnimatedSprite2D = $Slowdown


func _ready() -> void:
	hide_sprites()


func set_sprite(type: String = "Heart") -> void:
	print(type)
	match type:
		"heart":
			heart.visible = true
		"bomb":
			bomb.visible = true
		"slowdown":
			slowdown.visible = true
		_:
			heart.visible = true
	if event.note == "C4":
		helper_line.visible = true

func hide_sprites() -> void:
	heart.visible = false
	bomb.visible = false
	slowdown.visible = false
