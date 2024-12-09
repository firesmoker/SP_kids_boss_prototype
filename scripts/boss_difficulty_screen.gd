extends Control
class_name BossDifficultyScreen

@onready var load_overlay: TextureRect = $LoadOverlay
@onready var header_label: Label = $HeaderLabel

@onready var easy_button: Button = $EasyButton
@onready var medium_button: Button = $MediumButton
@onready var hard_button: Button = $HardButton

var model: Dictionary

func _ready() -> void:
	header_label.text = model.get("displayName", "")
	load_overlay.visible = false

	# Disable buttons if no level data exists for the difficulty
	var levels: Dictionary = model.get("levels", {})
	easy_button.disabled = not levels.has("easy")
	medium_button.disabled = not levels.has("medium")
	hard_button.disabled = not levels.has("hard")

func _on_EasyButton_pressed() -> void:
	prepare_game("easy")

func _on_MediumButton_pressed() -> void:
	prepare_game("medium")

func _on_HardButton_pressed() -> void:
	prepare_game("hard")

func prepare_game(difficulty: String) -> void:
	load_overlay.visible = true

	# Retrieve level data for the selected difficulty
	var levels: Dictionary = model.get("levels", {})
	var level_data: Dictionary = levels.get(difficulty, {})
	
	# Set game parameters
	Game.game_mode = "boss"
	Game.current_difficulty = difficulty
	Game.right_melody_path = level_data.get("melody_path", "")
	Game.left_melody_path = level_data.get("left_melody_path", "")
	Game.song_path = level_data.get("song_path", "")
	Game.slow_song_path = level_data.get("slow_song_path", "")
	Game.tempo = level_data.get("tempo", 0)
	Game.starting_player_health = level_data.get("player_life", 0)
	Game.starting_boss_health = level_data.get("boss_life", 0)
	Game.ui_type = level_data.get("ui_type", "")
	Game.on_display_duration = level_data.get("display_duration", 0)
	if "ending_music_path" in level_data:
		Game.ending_music_path = level_data.get("ending_music_path", null)

	# Start the level
	start_level()

func start_level() -> void:
	Game.game_state = "Intro"
	Game.repeat_requested = false
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.start()
	await timer.timeout
	timer.stop()
	move_to_core_game()

func move_to_core_game() -> void:
	var game: Game = NodeHelper.move_to_scene(self, "res://scenes/game.tscn")
	game.model = model

func _on_back_button_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/boss_screen.tscn", Callable(self, "on_screen_created"))
