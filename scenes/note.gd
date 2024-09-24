class_name Note extends AnimatableBody2D

var pitch: String = "G4"
@export_enum("Active", "Inactive", "Rest") var state: String = "Active"

func _ready() -> void:
	pass # Replace with function body.

func say_poop() -> void:
	print("poop")

func _process(delta: float) -> void:
	pass

func become_giant() -> void:
	scale = scale * 5
