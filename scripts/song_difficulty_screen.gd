extends Control

@onready var header_label: Label = $HeaderLabel
var model: Dictionary

func _ready() -> void:
	header_label.text = model.get("displayName")

func _on_EasyButton_pressed() -> void:
	print("Easy mode selected!")
	load_library_song(0.8)

func _on_MediumButton_pressed() -> void:
	print("Medium mode selected!")
	load_library_song(1)

func _on_HardButton_pressed() -> void:
	print("Hard mode selected!")
	load_library_song(1.2)
	
func load_library_song(tempo_multiplier: float) -> void:
	
	# Navigate to inGameInfo/melodyFiles/right
	if model.has("inGameInfo") and model["inGameInfo"].has("melodyFiles"):
		if model["inGameInfo"]["melodyFiles"].has("right"):
			Game.right_melody_path = "res://songs/" + model["inGameInfo"]["melodyFiles"]["right"]
		if model["inGameInfo"]["melodyFiles"].has("left"):
			Game.left_melody_path = "res://songs/" + model["inGameInfo"]["melodyFiles"]["left"]
		else:
			Game.left_melody_path = "res://levels/melody1_left.txt"
	
	var song_path: String = "res://songs/" + model["inGameInfo"]["bgm"]
	
	# Regular expression to match BPM in file names
	var bpm_pattern: String = r"(\d+)\s?(?:bpm|BPM)"

	# Compile the regular expression
	var regex: RegEx = RegEx.new()
	regex.compile(bpm_pattern)

	var tempo: float = float(regex.search(song_path).get_string(1))  # Extract the BPM value
	var new_tempo: int = int(tempo * tempo_multiplier)
	var new_song_path: String = regex.sub(song_path, "%sbpm" % str(new_tempo))
	Game.song_path = new_song_path
	
	Game.tempo = new_tempo
	Game.ui_type = model["uiType"].split("_")[0]
	Game.on_display_duration = float(model["inGameInfo"]["onScreenDisplayDuration"])
	Game.game_mode = "library"
	start_level("normal")


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
	NodeHelper.move_to_scene(self, "res://scenes/game.tscn")
		
