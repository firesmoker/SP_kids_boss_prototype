extends Control
class_name SongDifficultyScreen

@onready var load_overlay: TextureRect = $LoadOverlay

@onready var header_label: Label = $HeaderLabel
var model: Dictionary

func _ready() -> void:
	header_label.text = model.get("displayName")
	load_overlay.visible = false

func _on_EasyButton_pressed() -> void:
	print("Easy mode selected!")
	load_overlay.visible = true
	load_library_song("easy")

func _on_MediumButton_pressed() -> void:
	print("Medium mode selected!")
	load_overlay.visible = true
	load_library_song()

func _on_HardButton_pressed() -> void:
	print("Hard mode selected!")
	load_overlay.visible = true
	load_library_song("hard")
	
func load_library_song(difficulty: String = "") -> void:
	
	# Navigate to inGameInfo/melodyFiles/right
	if model.has("inGameInfo") and model["inGameInfo"].has("melodyFiles"):
		if model["inGameInfo"]["melodyFiles"].has("right"):
			Game.right_melody_path = "res://songs/" + model["inGameInfo"]["melodyFiles"]["right"]
		if model["inGameInfo"]["melodyFiles"].has("left"):
			Game.left_melody_path = "res://songs/" + model["inGameInfo"]["melodyFiles"]["left"]
		else:
			Game.left_melody_path = "res://levels/melody1_left.txt"
	
	var song_path: String = "res://songs/" + model["inGameInfo"]["bgm"]
	
	var tempo: float = float(get_bpm(Game.right_melody_path))  # Extract the BPM value
	var new_tempo: int = int(tempo * difficulty_to_tempo_multiplier(difficulty))
	var new_song_path: String = get_song_path(song_path, difficulty)
	Game.song_path = new_song_path
	
	Game.tempo = new_tempo
	Game.ui_type = model["uiType"].split("_")[0]
	Game.on_display_duration = float(model["inGameInfo"]["onScreenDisplayDuration"])
	Game.game_mode = "library"
	start_level("normal")
	
func difficulty_to_tempo_multiplier(difficulty: String) -> float:
	match difficulty:
		"easy":
			return 0.8
		"hard":
			return 1.2
		_:
			return 1.0  # Default value for other cases
			
			
func get_bpm(file_path: String) -> String:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content := file.get_as_text().strip_edges()  # Read the file and trim whitespace
		file.close()
		return content.split(",", false)[0]  # Split by ',' and return the first part
	return ""  # Return an empty string if the file could not be opened

func get_song_path(origina_path: String, difficulty: String) -> String:
	if difficulty == "easy":
		return origina_path.replace(".ogg", ".easy.ogg")
	elif difficulty == "hard":
		return origina_path.replace(".ogg", ".hard.ogg")
	else:
		return origina_path  # Return the original string for other cases

func start_level(type: String = "normal") -> void:
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
	NodeHelper.move_to_scene(self, "res://scenes/song_variation_screen.tscn", Callable(self, "on_screen_created"))

func on_screen_created(screen: Node) -> void:
	screen.model = model
	
