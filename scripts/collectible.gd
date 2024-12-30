class_name Collectible extends CollectibleMarker

@export_enum("Active", "Inactive") var state: String = "Active"
@onready var super_note_animation: AnimatedSprite2D = $SuperNoteAnimation
@onready var helper_line: Sprite2D = $HelperLine
@export var note: String
var effect: String = "slow_down"
@onready var bomb: AnimatedSprite2D = $Bomb
@onready var slowdown: AnimatedSprite2D = $Slowdown
@onready var slowdown_animation: AnimatedSprite2D = $SlowdownAnimation
@onready var stem: Sprite2D = $Stem
@onready var stem_sprite: Sprite2D = $Stem/Stem
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var note_root: Sprite2D = $NoteRoot
@onready var patzpatz: AnimatedSprite2D = $Patzpatz
@onready var fanta: AnimatedSprite2D = $Fanta

var changing_color: bool = false

func _ready() -> void:
	hide_sprites()
	on_visibility_changed()
	self.visibility_changed.connect(on_visibility_changed)


func set_sprite(type: String = "Heart") -> void:
	print(type)
	match type:
		"heart":
			stem.visible = false
			note_root.visible = false
			
			super_note_animation.visible = true
			super_note_animation.sprite_frames = load("res://scene_resources/heart_note_animation.tres")
			var animation_name: String = "stem_up"
			if stem.rotation > 0:
				animation_name = "stem_down"
				super_note_animation.position.y += 430
			super_note_animation.play(animation_name)
		"bomb":
			bomb.visible = true
		"slowdown":
			slowdown.visible = true
		"golden_note":
			stem.visible = false
			note_root.visible = false
			
			super_note_animation.visible = true
			super_note_animation.sprite_frames = load("res://scene_resources/gold_note_animation.tres")
			var animation_name: String = "stem_up"
			super_note_animation.position.y -= 10
			if stem.rotation > 0:
				animation_name = "stem_down"
				super_note_animation.position.y += 400
			super_note_animation.play(animation_name)
		_:
			pass
	if note == "C4":
		helper_line.visible = true

func hide_sprites() -> void:
	super_note_animation.visible = false
	bomb.visible = false
	slowdown.visible = false
	helper_line.visible = false

func play_animation(type: String = "Heart") -> void:
	#hide_sprites()
	helper_line.visible = false
	stem.visible = false
	match type:
		"slowdown":
			slowdown_animation.visible = true
			slowdown_animation.play()
		_:
			pass

func appear(toggle: bool) -> void:
	self.visible = toggle
	self.collision.disabled = !toggle

func on_visibility_changed() -> void:
	if visible and event.subtype == "slowdown":
		var game: Game = NodeHelper.get_ancestor_game(self)
		var texture_progress_bar: TextureProgressBar = game.player_health_bar
		var player_health: float = (texture_progress_bar.value - texture_progress_bar.min_value) / (texture_progress_bar.max_value - texture_progress_bar.min_value)
		# if Game.last_game_lost:
		#   appear(true)
		# else:
		appear(false)
			

func hit_golden_note_visual() -> void:
	#fanta.play()
	changing_color = true
	patzpatz.visible = true
	patzpatz.play()
	var expander: Expander = super_note_animation.find_child("Expander")
	if expander:
		expander.expand(1.5,0.13,true)
