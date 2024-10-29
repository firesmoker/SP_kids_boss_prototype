extends Node2D

@onready var darken: TextureRect = $UI/Darken
@onready var difficulty: Panel = $UI/Difficulty
@onready var easy_button: Button = $UI/Difficulty/EasyButton
#@onready var normal_button: Button = $UI/Difficulty/NormalButton
#@onready var hard_button: Button = $UI/Difficulty/HardButton
@onready var song_buttons: ScrollContainer = $UI/SongButtons
@onready var auto_play_toggle: CheckButton = $UI/AutoPlayToggle
@onready var library_song_toggle: CheckButton = $UI/LibrarySongToggle
@onready var debug_toggle: CheckButton = $UI/DebugToggle

@onready var load_overlay: TextureRect = $UI/LoadOverlay
var default_left_melody: String = "res://levels/melody1_left.txt"
@export_group("Just Can't Wait")
@export var song_1_path: String
@export var song_1_slow_song_path: String
@export var song_1_melody_path: String
@export var song_1_easy_path: String
@export var song_1_easy_slow_song_path: String
@export var song_1_easy_melody_path: String
@export var song_1_hard_melody_path: String
@export_group("Circle of Life")
@export var song_2_path: String
@export var song_2_slow_song_path: String
@export var song_2_melody_path: String
@export var song_2_easy_melody_path: String
@export var song_2_hard_melody_path: String
@export_group("Let it Go")
@export var song_3_song_path: String
@export var song_3_slow_song_path: String
@export var song_3_melody_path: String
@export var song_3_hard_melody_path: String
@export_group("Hokey Pokey")
@export var song_4_song_path: String
@export var song_4_slow_song_path: String
@export var song_4_melody_path: String
@export var song_4_hard_melody_path: String
@export_group("Free Fallin")
@export var song_5_song_path: String
@export var song_5_slow_song_path: String
@export var song_5_melody_path: String
@export var song_5_hard_melody_path: String
@export_group("Dance Monkey")
@export var song_6_song_path: String
@export var song_6_slow_song_path: String
@export var song_6_melody_path: String
@export var song_6_left_melody_path: String
@export var song_6_left_hard_melody_path: String
@export_group("Pokemon")
@export var song_7_song_path: String
@export var song_7_slow_song_path: String
@export var song_7_melody_path: String
@export var song_7_left_melody_path: String
@export var song_7_left_hard_melody_path: String
@export_group("Believer")
@export var song_8_song_path: String
@export var song_8_slow_song_path: String
@export var song_8_melody_path: String
@export var song_8_left_melody_path: String
@export_group("Jingle Bells")
@export var song_9_song_path: String
@export var song_9_slow_song_path: String
@export var song_9_melody_path: String
@export var song_9_left_melody_path: String
@export var song_9_hard_melody_path: String
@export var song_9_left_hard_melody_path: String
@export_group("Let It March!")
@export var song_10_song_path: String
@export var song_10_slow_song_path: String
@export var song_10_melody_path: String
@export var song_10_hard_melody_path: String


var maximum_input_distance: float = 100
var current_press_position: Vector2

func _ready() -> void:
	load_overlay.visible = false
	darken.visible = false
	difficulty.visible = false
	
	connect_buttons()
	auto_play_toggle.set_pressed_no_signal(Game.cheat_auto_play)
	debug_toggle.set_pressed_no_signal(Game.debug)
	if Game.game_mode == "library":
		library_song_toggle.set_pressed_no_signal(true)
	else:
		library_song_toggle.set_pressed_no_signal(false)
	

func connect_buttons() -> void:	
	var vbox_container: VBoxContainer = song_buttons.find_child("VBoxContainer")
	var all_song_buttons: Array = vbox_container.get_children()
	for button: Button in all_song_buttons:
		button.connect("button_down", get_input_press_position)


func start_level(type: String = "normal") -> void:
	Game.game_state = "Intro"
	Game.repeat_requested = false
	load_overlay.visible = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.start()
	await timer.timeout
	timer.stop()
	LevelSelector.set_level(type)
	
	get_tree().change_scene_to_packed(LevelSelector.new_scene_source)



func _on_button1_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons(true)
		Game.has_easy_difficulty = true
		define_easy_level(song_1_easy_melody_path,default_left_melody,song_1_easy_path,song_1_easy_slow_song_path, 70, 8, 30,2.5, "treble")
		define_level(song_1_melody_path,default_left_melody,song_1_path,song_1_slow_song_path, 76, 8, 30,2.5, "treble")
		define_hard_level(song_1_hard_melody_path,default_left_melody,song_1_path,song_1_slow_song_path, 76, 6, 31, 2.5, "treble")


func _on_button2_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_2_melody_path,default_left_melody,song_2_path,song_2_slow_song_path,78, 7, 26)
		define_easy_level(song_2_melody_path,default_left_melody,song_2_path,song_2_slow_song_path,78, 4, 15)
		define_hard_level(song_2_hard_melody_path,default_left_melody,song_2_path,song_2_slow_song_path,78, 6, 35) #39-8 -> 


func _on_button3_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_3_melody_path,default_left_melody,song_3_song_path,song_3_slow_song_path,106,5, 20, 3)
		define_easy_level(song_3_melody_path,default_left_melody,song_3_song_path,song_3_slow_song_path,106,5, 20, 3)
		define_hard_level(song_3_hard_melody_path,default_left_melody,song_3_song_path,song_3_slow_song_path,106,6, 31, 3)


func _on_button_4_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_4_melody_path,default_left_melody,song_4_song_path,song_4_slow_song_path,88,9,35)
		define_easy_level(song_4_melody_path,default_left_melody,song_4_song_path,song_4_slow_song_path,88,9,35)
		define_hard_level(song_4_hard_melody_path,default_left_melody,song_4_song_path,song_4_slow_song_path,88,8,40)


func _on_button_5_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_5_melody_path,default_left_melody,song_5_song_path,song_5_slow_song_path,155,13, 51)
		define_easy_level(song_5_melody_path,default_left_melody,song_5_song_path,song_5_slow_song_path,155,13, 51)
		define_hard_level(song_5_hard_melody_path,default_left_melody,song_5_song_path,song_5_slow_song_path,155,13, 55)


func _on_button_6_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_6_melody_path,song_6_left_melody_path,song_6_song_path,song_6_slow_song_path,85,6, 23,2.5, "both")
		define_easy_level(song_6_melody_path,song_6_left_melody_path,song_6_song_path,song_6_slow_song_path,85,6, 23,2.5, "both")
		define_hard_level(song_6_melody_path,song_6_left_hard_melody_path,song_6_song_path,song_6_slow_song_path,85,8, 33, 2.5, "both")


func _on_button_7_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_7_melody_path,song_7_left_melody_path,song_7_song_path,song_7_slow_song_path,115,4, 23,2.5, "both")
		define_easy_level(song_7_melody_path,song_7_left_melody_path,song_7_song_path,song_7_slow_song_path,115,4, 23,2.5, "both")
		define_hard_level(song_7_melody_path,song_7_left_hard_melody_path,song_7_song_path,song_7_slow_song_path,115,6, 26, 2.5, "both")


func _on_button_8_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23,2.5, "both")
		define_easy_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23,2.5, "both")
		define_hard_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23, 2.5, "both")

func _on_button_9_button_up() -> void:
	if unpressed_accepted():
		print("close!")
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_9_melody_path,song_9_left_melody_path,song_9_song_path,song_9_slow_song_path,88,10, 38,2.5, "both")
		define_easy_level(song_9_melody_path,song_9_left_melody_path,song_9_song_path,song_9_slow_song_path,88,10, 38,2.5, "both")
		define_hard_level(song_9_hard_melody_path,song_9_left_hard_melody_path,song_9_song_path,song_9_slow_song_path,88,12, 47, 2.5, "both")

func _on_button10_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		Game.has_easy_difficulty = false
		define_level(song_10_melody_path,default_left_melody,song_10_song_path,song_10_slow_song_path,106,5, 20, 3)
		define_easy_level(song_10_melody_path,default_left_melody,song_10_song_path,song_10_slow_song_path,106,5, 20, 3)
		define_hard_level(song_10_hard_melody_path,default_left_melody,song_10_song_path,song_10_slow_song_path,106,6, 31, 3)		

func unpressed_accepted() -> bool:
	var current_unpressed_position: Vector2 = get_global_mouse_position()
	if current_unpressed_position.distance_to(current_press_position) > 300:
		return false
	else:
		return true

func _on_easy_button_button_up() -> void:
	start_level("easy")

func _on_normal_button_button_up() -> void:
	start_level("normal")


func _on_hard_button_button_up() -> void:
	start_level("hard")
	

func define_easy_level(melody_path: String, left_melody_path: String, song_path: String,
				slow_song_path: String, tempo: float,
				player_life: float, boss_life: float, display_duration: float = 2.5, ui_type: String = "treble") -> void:
	LevelSelector.easy_melody_path = melody_path
	LevelSelector.easy_left_melody_path = left_melody_path
	LevelSelector.easy_song_path = song_path
	LevelSelector.easy_slow_song_path = slow_song_path
	LevelSelector.easy_tempo = tempo
	LevelSelector.easy_player_life = player_life
	LevelSelector.easy_boss_life = boss_life
	LevelSelector.easy_ui_type = ui_type
	LevelSelector.easy_display_duration = display_duration

	
func define_level(melody_path: String, left_melody_path: String, song_path: String,
				slow_song_path: String, tempo: float,
				player_life: float, boss_life: float, display_duration: float = 2.5, ui_type: String = "treble") -> void:
	LevelSelector.normal_melody_path = melody_path
	LevelSelector.normal_left_melody_path = left_melody_path
	LevelSelector.normal_song_path = song_path
	LevelSelector.normal_slow_song_path = slow_song_path
	LevelSelector.normal_tempo = tempo
	LevelSelector.normal_player_life = player_life
	LevelSelector.normal_boss_life = boss_life
	LevelSelector.normal_ui_type = ui_type
	LevelSelector.normal_display_duration = display_duration

func define_hard_level(melody_path: String, left_melody_path: String, song_path: String,
				slow_song_path: String, tempo: float,
				player_life: float, boss_life: float, display_duration: float = 2.5, ui_type: String = "treble") -> void:
	LevelSelector.hard_melody_path = melody_path
	LevelSelector.hard_left_melody_path = left_melody_path
	LevelSelector.hard_song_path = song_path
	LevelSelector.hard_slow_song_path = slow_song_path
	LevelSelector.hard_tempo = tempo
	LevelSelector.hard_player_life = player_life
	LevelSelector.hard_boss_life = boss_life
	LevelSelector.hard_ui_type = ui_type
	LevelSelector.hard_display_duration = display_duration

func show_difficulty_buttons(show_easy: bool = false) -> void:
	if show_easy:
		easy_button.visible = true
	else:
		easy_button.visible = false
	song_buttons.visible = false
	darken.visible = true
	difficulty.visible = true



func get_input_press_position() -> void:
	current_press_position = get_global_mouse_position()


func _on_auto_play_toggle_toggled(toggled_on: bool) -> void:
	Game.cheat_auto_play = toggled_on


func _on_library_song_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Game.game_mode = "library"
	else:
		Game.game_mode = "boss"


func _on_debug_toggle_toggled(toggled_on: bool) -> void:
	Game.debug = toggled_on
