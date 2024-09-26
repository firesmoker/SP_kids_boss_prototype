class_name Bomb extends AnimatableBody2D

@export_enum("Active", "Inactive") var state: String = "Active"
@export var event: MelodyEvent
@onready var helper_line: Sprite2D = $HelperLine
@onready var texture: Sprite2D = $Texture

var fade_duration: float = 0.25
var fade_speed: float = 0.5
var target_scale: Vector2 = Vector2(1.25, 1.25)
var original_scale: Vector2  # Store the original scale
var fading: bool = false  # Flag to control fading state

func hit_note_visual() -> void:
	#scale = scale * 1.6
	fade_out()
	state = "Inactive"

func miss_note_visual() -> void:
	pass
	#texture.material.set_shader_parameter("color",Color.RED)

func fade_out() -> void:
	fading = true  
	scale = original_scale 
	modulate.a = 1.0


func _process(delta: float) -> void:
	if fading:
		var fade_amount: float = (delta / fade_duration)
		modulate.a -= fade_amount
		scale.x = lerp(original_scale.x, target_scale.x, 1.0 - (modulate.a / 1.0))
		scale.y = lerp(original_scale.y, target_scale.y, 1.0 - (modulate.a / 1.0))

		# Ensure the alpha and scale don't go below the minimum
		if modulate.a <= 0:
			modulate.a = 0
			queue_free()  # Remove the object from the scene
			fading = false  # Stop the fading state
