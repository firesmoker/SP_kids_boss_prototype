class_name Note extends AnimatableBody2D

@export_enum("Active", "Inactive", "Rest") var state: String = "Active"
var note: String
var event: MelodyEvent
@export_enum("Note","Rest") var type: String = "Note"
@export var success_color: Color
@onready var eigth: Sprite2D = $Eigth
@onready var quarter: Sprite2D = $Quarter
@onready var half: Sprite2D = $Half
@onready var whole: Sprite2D = $Whole
@onready var stem: Sprite2D = $Stem
@onready var helper_line: Sprite2D = $HelperLine


func ready() -> void:
	eigth.material.set_shader_parameter("color",Color.BLACK)
	quarter.material.set_shader_parameter("color",Color.BLACK)
	half.material.set_shader_parameter("color",Color.BLACK)
	whole.material.set_shader_parameter("color",Color.BLACK)


func hit_note_visual() -> void:
	#scale = scale * 1.6
	eigth.material.set_shader_parameter("color",success_color)
	quarter.material.set_shader_parameter("color",success_color)
	half.material.set_shader_parameter("color",success_color)
	whole.material.set_shader_parameter("color",success_color)

func miss_note_visual() -> void:
	eigth.material.set_shader_parameter("color",Color.RED)
	quarter.material.set_shader_parameter("color",Color.RED)
	half.material.set_shader_parameter("color",Color.RED)
	whole.material.set_shader_parameter("color",Color.RED)

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
