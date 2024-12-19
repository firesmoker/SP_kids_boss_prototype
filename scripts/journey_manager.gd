extends Node
class_name JourneyManager

const BOSSES_FILE_PATH: String = "boss/boss.json"
const JOURNEY_FILE_PATH: String = "journey/journey.json"

static var bosses_data: Array = []
static var model: Dictionary = {}
static var current_params: Dictionary = {}  # To store the current parameters

# Load bosses data from the boss.json file
static func load_bosses() -> void:
	var json_data: String = StateManager.load_state(BOSSES_FILE_PATH)
	bosses_data = JSON.parse_string(json_data)

static func set_current_scene(params: Dictionary) -> void:
	if not params.has("type") or not params.has("id"):
		print("Invalid in-game params:", params)
		return

	# Save the current parameters
	current_params = params

# Launch a scene based on in-game-params and save the parameters
static func launch_scene(node: Node, params: Dictionary, difficulty: String = "medium") -> void:
	match params["type"]:
		"boss":
			if params["id"].begins_with("boss://"):
				load_bosses()
				launch_boss_scene(node, params["id"], difficulty)
			else:
				print("Unknown boss ID:", params["id"])
		"character-selection":
			if params["id"].begins_with("character://"):
				NodeHelper.move_to_scene(node, "res://scenes/characters_screen.tscn")
			else:
				print("Unknown character selection ID:", params["id"])
		_:
			print("Unknown type:", params["type"])

# Launch the boss scene by setting up the model and game parameters
static func launch_boss_scene(node: Node, boss_id: String, difficulty: String) -> void:
	for boss: Dictionary in bosses_data:
		if boss.get("id") == boss_id:
			model = boss
			prepare_game_parameters(difficulty)
			move_to_core_game(node)
			return

	print("Boss with ID not found:", boss_id)

# Prepare game parameters based on the selected difficulty
static func prepare_game_parameters(difficulty: String) -> void:
	var levels: Dictionary = model.get("levels", {})
	var level_data: Dictionary = levels.get(difficulty, {})

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
	Game.on_display_duration = level_data.get("display_duration", 0.0)
	if level_data.has("ending_music_path"):
		Game.ending_music_path = level_data.get("ending_music_path", null)

# Move to the core game scene and set the model
static func move_to_core_game(node: Node) -> void:
	var game: Game = NodeHelper.move_to_scene(node, "res://scenes/game.tscn")
	game.model = model

# Mark a level as complete by setting is_complete to true
static func mark_level_as_complete(level_type: String, level_id: String) -> void:
	# Read the existing JSON data
	var json_data: String = StateManager.load_state(JOURNEY_FILE_PATH)

	# Parse the JSON data
	var journey_data: Array = JSON.parse_string(json_data)

	# Find and mark the level as complete
	for level: Dictionary in journey_data:
		if level.has("in-game-params"):
			var params: Dictionary = level["in-game-params"]
			if params.get("type") == level_type and params.get("id") == level_id:
				level["is_complete"] = true
				print("Marked level as complete:", level_type, level_id)
				break

	StateManager.save_state(JOURNEY_FILE_PATH, journey_data)

# Mark the current level as complete using saved parameters
static func mark_current_level_as_complete() -> void:
	if current_params != {}:
		var level_type: String = current_params.get("type", "")
		var level_id: String = current_params.get("id", "")
		if level_type and level_id:
			mark_level_as_complete(level_type, level_id)
			current_params = {}  # Reset the current parameters after marking complete
		else:
			print("Invalid current parameters:", current_params)
	else:
		print("No current level parameters to mark as complete.")

# Launch the current level using the saved current_params
static func launch_current_level(node: Node, difficulty: String = "medium") -> void:
	if current_params != {}:
		launch_scene(node, current_params, difficulty)
	else:
		print("No current level parameters to launch.")
