extends Node
class_name JourneyLauncher

const BOSSES_FILE_PATH: String = "res://boss/boss.json"
var bosses_data: Array = []
var model: Dictionary = {}

# Load bosses data from the boss.json file
func load_bosses() -> void:
	var file: FileAccess = FileAccess.open(BOSSES_FILE_PATH, FileAccess.ModeFlags.READ)
	if file:
		var json_data: String = file.get_as_text()
		file.close()
		bosses_data = JSON.parse_string(json_data)
	else:
		print("Failed to open file at path:", BOSSES_FILE_PATH)

# Launch a scene based on in-game-params
func launch_scene(node: Node, params: Dictionary, difficulty: String = "medium") -> void:
	if not params.has("type") or not params.has("id"):
		print("Invalid in-game params:", params)
		return

	match params.type:
		"boss":
			if params.id.begins_with("boss://"):
				load_bosses()
				launch_boss_scene(node, params.id, difficulty)
			else:
				print("Unknown boss ID:", params.id)
		"character-selection":
			if params.id.begins_with("character://"):
				NodeHelper.move_to_scene(node, "res://scenes/characters_screen.tscn")
			else:
				print("Unknown character selection ID:", params.id)
		_:
			print("Unknown type:", params.type)

# Launch the boss scene by setting up the model and game parameters
func launch_boss_scene(node: Node, boss_id: String, difficulty: String) -> void:
	# Find the boss with the matching ID
	for boss: Dictionary in bosses_data:
		if boss.get("id") == boss_id:
			model = boss
			prepare_game_parameters(difficulty)
			move_to_core_game(node)
			return

	print("Boss with ID not found:", boss_id)

# Prepare game parameters based on the selected difficulty
func prepare_game_parameters(difficulty: String) -> void:
	var levels: Dictionary = model.get("levels", {})
	var level_data: Dictionary = levels.get(difficulty, {})

	# Set game parameters
	Game.song_id = model.get("id", "")
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
	if level_data.has("ending_music_path"):
		Game.ending_music_path = level_data.get("ending_music_path", null)

# Move to the core game scene and set the model
func move_to_core_game(node: Node) -> void:
	var game: Game = NodeHelper.move_to_scene(node, "res://scenes/game.tscn")
	game.model = model
