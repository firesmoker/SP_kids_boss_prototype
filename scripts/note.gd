class_name Note extends AnimatableBody2D

@export_enum("Active", "Inactive", "Rest") var state: String = "Active"
var note: String
var event: MelodyEvent
@export_enum("Note","Rest") var type: String = "Note"
@export var success_color: Color # 29f3ee
@export var starting_success_color: Color # 29f3ee
@onready var eigth: Sprite2D = $HeadSprites/Eigth
@onready var quarter: Sprite2D = $HeadSprites/Quarter
@onready var half: Sprite2D = $HeadSprites/Half
@onready var whole: Sprite2D = $HeadSprites/Whole
@onready var stem: Sprite2D = $Stem
@onready var helper_line: Sprite2D = $HeadSprites/HelperLine
@onready var head_sprites: Node2D = $HeadSprites
@onready var patzpatz: AnimatedSprite2D = $Patzpatz
@onready var fanta: AnimatedSprite2D = $Fanta
var changing_color: bool = false
var current_color: Color
var original_color: Color = Color.BLACK
var success_progress: float = 0
var changing_color_modifier: float = 1.5


func ready() -> void:
	original_color = Color.BLACK
	current_color = original_color
	patzpatz.visible = false
	eigth.material.set_shader_parameter("color",Color.BLACK)
	quarter.material.set_shader_parameter("color",Color.BLACK)
	half.material.set_shader_parameter("color",Color.BLACK)
	whole.material.set_shader_parameter("color",Color.BLACK)

func _process(delta: float) -> void:
	if changing_color:
		changing_color_modifier += 0.05
		success_progress = clampf(success_progress + delta * changing_color_modifier,0,1)
		current_color = lerp(starting_success_color,success_color,success_progress)
		eigth.material.set_shader_parameter("color",current_color)
		quarter.material.set_shader_parameter("color",current_color)
		half.material.set_shader_parameter("color",current_color)
		whole.material.set_shader_parameter("color",current_color)

func hit_note_visual(note_score: float) -> void:
	#scale = scale * 1.6
	if not Game.sp_mode:
		if not Game.game_mode == "boss":
			pass
			if note_score < 0.9:
				fanta.scale.x *= 0.3
			fanta.play()
		changing_color = true
		var expander: Expander = head_sprites.find_child("Expander")
		if note_score > 0.9:
			if not Game.game_mode == "boss":
				patzpatz.visible = true
				patzpatz.play("stars")
			if expander:
				expander.expand(1.5,0.13,true)
		elif not Game.game_mode == "boss":
			patzpatz.visible = true
			patzpatz.scale *= 0.75
			patzpatz.modulate.a = 0.25
			patzpatz.play("normal")
			#var patzpatz_shadow: AnimatedSprite2D = patzpatz.find_child("Shadow")
			#if patzpatz_shadow:
				#patzpatz_shadow.play("normal")
			if expander:
				expander.expand(1.25,0.13,true)
	else:
		eigth.material.set_shader_parameter("color",starting_success_color)
		quarter.material.set_shader_parameter("color",starting_success_color)
		half.material.set_shader_parameter("color",starting_success_color)
		whole.material.set_shader_parameter("color",starting_success_color)

func miss_note_visual() -> void:
	eigth.material.set_shader_parameter("color",Color.RED)
	quarter.material.set_shader_parameter("color",Color.RED)
	half.material.set_shader_parameter("color",Color.RED)
	whole.material.set_shader_parameter("color",Color.RED)

func set_duration_visual(duration: float) -> void:
	quarter.visible = false
	eigth.visible = false
	half.visible = false
	whole.visible = false
	patzpatz.visible = false
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
