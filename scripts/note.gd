class_name Note extends AnimatableBody2D

@export_enum("Active", "Inactive", "Rest") var state: String = "Active"
@export var note: String
@export var event: MelodyEvent
@export var is_gold: bool = false
@export_enum("Note","Rest") var type: String = "Note"
@onready var eigth: Sprite2D = $Eigth
@onready var quarter: Sprite2D = $Quarter
@onready var half: Sprite2D = $Half
@onready var whole: Sprite2D = $Whole
@onready var stem: Sprite2D = $Stem
@onready var helper_line: Sprite2D = $HelperLine


func _ready() -> void:
	var details: Dictionary = event.details
	if details.has("action") and details["action"] == "gold":
		is_gold = true
	for sprite: Sprite2D in [eigth, quarter, half, whole]:
		sprite.material.set_shader_parameter("color",color())


func hit_note_visual() -> void:
	#scale = scale * 1.6
	for sprite: Sprite2D in [eigth, quarter, half, whole]:
		sprite.material.set_shader_parameter("color",Color.CADET_BLUE)

func miss_note_visual() -> void:
	for sprite: Sprite2D in [eigth, quarter, half, whole]:
		sprite.material.set_shader_parameter("color",Color.RED)

func set_duration_visual(duration: float) -> void:
	if stem:
		stem.visible = true
	if helper_line:
		helper_line.visible = false
		if note == "C4":
			helper_line.visible = true
	match duration:
		0.125:
			eigth.visible = true
		0.25:
			quarter.visible = true
		0.5:
			half.visible = true
		1.0:
			whole.visible = true
			if stem:
				stem.visible = false
		_:
			print("oh shit")
			scale = scale * 1.6
	if state == "Rest":
		if stem:
			stem.visible = false

func color() -> Color:
	if is_gold:
		return Color.GOLD 
	else:
		return Color.BLACK
