extends Node2D


@onready var load_overlay: TextureRect = $UI/LoadOverlay


func _ready() -> void:
	load_overlay.visible = false

func _on_button_button_up() -> void:
	load_overlay.visible = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start()
	await timer.timeout
	var new_scene_source: PackedScene = load(Game.game_scene)
	Game.game_state = "Playing"
	get_tree().change_scene_to_packed(new_scene_source)
