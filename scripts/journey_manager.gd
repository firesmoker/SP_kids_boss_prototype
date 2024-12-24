extends Node
class_name JourneyManager

# Constants for base paths
const CHARACTERS_FILE_BASE_PATH: String = "characters/characters"
const LEVELS_FILE_BASE_PATH: String = "journey/journey"
const BOSSES_FILE_BASE_PATH: String = "boss/boss.json"

static var model: Dictionary = {}
static var current_level: Dictionary = {}  # To store the current parameters

# Function to get the characters file path based on Game.gender
static func get_characters_file_path() -> String:
	var gender_suffix: String = "-boys.json" if Game.gender == "boy" else "-girls.json"
	return CHARACTERS_FILE_BASE_PATH + gender_suffix

# Function to get the levels file path based on Game.gender
static func get_levels_file_path() -> String:
	var gender_suffix: String = "-boys.json" if Game.gender == "boy" else "-girls.json"
	return LEVELS_FILE_BASE_PATH + gender_suffix

# Load characters data
static func load_characters() -> String:
	var characters_file_path: String = get_characters_file_path()
	var json_data: String = StateManager.load_state(characters_file_path)
	return json_data

# Load levels data
static func load_levels() -> String:
	var levels_file_path: String = get_levels_file_path()
	var json_data: String = StateManager.load_state(levels_file_path)
	return json_data

static func load_bosses() -> Array:
	var json_data: String = StateManager.load_state(BOSSES_FILE_BASE_PATH)
	return JSON.parse_string(json_data)

static func set_current_level(params: Dictionary) -> void:
	if not params.has("type") or not params.has("id"):
		print("Invalid in-game params:", params)
		return

	# Save the current parameters
	current_level = params

# Launch a scene based on in-game-params and save the parameters
static func launch_level(node: Node, params: Dictionary) -> void:
	match params["type"]:
		"boss":
			if params["id"].begins_with("boss://"):
				load_levels()
				apply_boss_parameters(params)
				launch_boss_scene(node, params["id"])
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
static func launch_boss_scene(node: Node, boss_id: String) -> void:
	var bosses_data: Array = JourneyManager.load_bosses()
	for boss: Dictionary in bosses_data:
		if boss.get("id") == boss_id:
			model = boss
			prepare_game_parameters()
			move_to_core_game(node)
			return

	print("Boss with ID not found:", boss_id)

static func apply_boss_parameters(model: Dictionary) -> void:
	Game.boss_name = model.get("name","")
	Game.boss_id = model.get("boss", "")
	Game.boss_model = model.get("boss_model", "")
	Game.heart_healing_bonus = model.get("heart_healing_bonus", 0)
	print("Boss Name:", Game.boss_name)
	print("Boss Id:", Game.boss_id)

# Prepare game parameters based on the selected difficulty
static func prepare_game_parameters() -> void:
	var levels: Dictionary = model.get("levels", {})
	var difficulty: String = Game.current_difficulty if Game.current_difficulty else "easy"
	var level_data: Dictionary = levels.get(difficulty)

	Game.song_id = model.get("id", "")
	Game.game_mode = "boss"
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
	var json_data: String = load_levels()

	# Parse the JSON data
	var journey_data: Array = JSON.parse_string(json_data)

	# Find and mark the level as complete and unlock the next level
	var unlock_next: bool = false

	for level: Dictionary in journey_data:
		if level.has("in-game-params"):
			var params: Dictionary = level["in-game-params"]
			if unlock_next:
				level["state"] = "unlocked"
				print("Unlocked next level:", params.get("id", ""))
				unlock_next = false  # Only unlock one level
				break
			if params.get("type") == level_type and params.get("id") == level_id:
				level["is_complete"] = true
				print("Marked level as complete:", level_type, level_id)
				unlock_next = true  # Flag to unlock the next level in the list

	StateManager.save_state(get_levels_file_path(), journey_data)

# Mark the current level as complete using saved parameters
static func mark_current_level_as_complete() -> void:
	if current_level != {}:
		var level_type: String = current_level.get("type", "")
		var level_id: String = current_level.get("id", "")
		if level_type and level_id:
			mark_level_as_complete(level_type, level_id)
		else:
			print("Invalid current parameters:", current_level)
	else:
		print("No current level parameters to mark as complete.")

# Launch the current level using the saved current_level
static func launch_current_level(node: Node) -> void:
	if current_level != {}:
		launch_level(node, current_level)
	else:
		print("No current level parameters to launch.")
		

# Save the scroll position to the journey file
static func save_scroll_position(scroll_position: int) -> void:
	var json_data: String = load_levels()
	var journey_data: Array = JSON.parse_string(json_data)

	var found: bool = false
	for entry: Dictionary in journey_data:
		if entry.has("scroll_position"):
			entry["scroll_position"] = scroll_position
			found = true
	
	if not found:
		journey_data.append({"scroll_position": scroll_position})
		
	StateManager.save_state(get_levels_file_path(), journey_data)
	
# Load the scroll position from the journey file
static func load_scroll_position() -> int:
	var json_data: String = load_levels()
	var journey_data: Array = JSON.parse_string(json_data)

	for entry: Dictionary in journey_data:
		if entry.has("scroll_position"):
			return entry["scroll_position"]

	return 0
