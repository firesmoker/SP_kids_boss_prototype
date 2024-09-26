extends Node2D




func _on_button_button_up() -> void:
	var new_scene_source: PackedScene = load(Game.game_scene)
	Game.game_state = "Playing"
	get_tree().change_scene_to_packed(new_scene_source)
