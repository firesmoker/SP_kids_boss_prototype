class_name Collectible extends CollectibleMarker

@export_enum("Active", "Inactive") var state: String = "Active"
@onready var helper_line: Sprite2D = $HelperLine
@export var note: String
var effect: String = "slow_down"
@onready var heart: AnimatedSprite2D = $Heart
@onready var heart_animation: AnimatedSprite2D = $HeartAnimation
@onready var bomb: AnimatedSprite2D = $Bomb
@onready var slowdown: AnimatedSprite2D = $Slowdown
@onready var slowdown_animation: AnimatedSprite2D = $SlowdownAnimation
@onready var stem: Sprite2D = $Stem


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
	if note == "C4":
		helper_line.visible = true

func hide_sprites() -> void:
	heart.visible = false
	bomb.visible = false
	slowdown.visible = false
	helper_line.visible = false

func play_animation(type: String = "Heart") -> void:
	#hide_sprites()
	helper_line.visible = false
	stem.visible = false
	match type:
		"heart":
			heart_animation.visible = true
			heart_animation.play()
		"bomb":
			pass
		"slowdown":
			slowdown_animation.visible = true
			slowdown_animation.play()
		_:
			pass
