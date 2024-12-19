# SettingsManager.gd
extends Node
class_name SettingsManager

# Define the file path for your settings file
const SETTINGS_PATH: String = "settings/settings.json"

# Dictionary to store your settings with default values
var settings: Dictionary = {
}

# Load settings when the game starts
func _ready() -> void:
	load_settings()

# Save settings to a JSON file
func save_settings() -> void:
	StateManager.save_state(SETTINGS_PATH, settings)

# Load settings from the JSON file
func load_settings() -> void:
	var data: String = StateManager.load_state(SETTINGS_PATH)
	if not data:
		return
		
	settings = JSON.parse_string(data)
	Game.debug = settings.get("debug_toggle", false)
	
	if settings.get("boss_toggle", false):
		Game.boss_model = "robot_"
	else:
		Game.boss_model = ""
		
	Game.cheat_auto_play = settings.get("auto_play_toggle", false)
	if settings.get("library_song_toggle", false):
		Game.game_mode = "library"
	else:
		Game.game_mode = "boss"
		
	Game.cheat_skip_middle_c = settings.get("skip_middle_c", false)
	Game.cheat_skip_intro = settings.get("skip_intro", false)
	Game.sp_mode = settings.get("sp_toggle", false)
	Game.score_based_stars = settings.get("score_based_stars", false)
	Game.cheat_play_piano_sounds = settings.get("play_piano_sounds", false)
	Game.gender = settings.get("gender", "boy")

	Game.cheat_auto_play = settings.get("auto_play_toggle", false)
	Game.debug = settings.get("debug_toggle", false)
	Game.cheat_skip_intro = settings.get("skip_intro", false)
	Game.cheat_skip_middle_c = settings.get("skip_middle_c", false)
	Game.current_difficulty = settings.get("current_difficulty", "easy")
