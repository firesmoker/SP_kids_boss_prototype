class_name Collectible extends AnimatableBody2D

@export_enum("Active", "Inactive") var state: String = "Active"
@export var event: MelodyEvent
@onready var helper_line: Sprite2D = $HelperLine
@onready var sprite: Sprite2D = $Sprite
var effect: String = "slow_down"
