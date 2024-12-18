extends Window

@onready var darken: TextureRect = $UI/Darken
@onready var song_buttons: ScrollContainer = $UI/SongButtons
@onready var auto_play_toggle: CheckButton = $UI/DevButtons/AutoPlayToggle
@onready var library_song_toggle: CheckButton = $UI/DevButtons/LibrarySongToggle
@onready var debug_toggle: CheckButton = $UI/DevButtons/DebugToggle
@onready var skip_intro: CheckButton = $"UI/DevButtons/Skip Intro"
@onready var skip_middle_c: CheckButton = $UI/DevButtons/SkipMiddleC
@onready var dev_buttons: Control = $UI/DevButtons
@onready var boss_toggle: CheckButton = $UI/DevButtons/BossToggle
@onready var settings_manager: SettingsManager = $SettingsManager
@onready var show_library_toggle: CheckButton = $UI/DevButtons/ShowLibraryToggle
@onready var character_selection: OptionButton = $UI/DevButtons/CharacterSelection
@onready var girl_selection: OptionButton = $UI/DevButtons/GirlSelection
@onready var boy_selection: OptionButton = $UI/DevButtons/BoySelection

@onready var sp_toggle: CheckButton = $UI/DevButtons/SPToggle
@onready var play_piano_toggle: CheckButton = $"UI/DevButtons/Play Piano"
@onready var new_stars_toggle: CheckButton = $"UI/DevButtons/New Stars"
@onready var boy_girl_toggle: CheckButton = $UI/DevButtons/BoyGirlToggle



@onready var load_overlay: TextureRect = $UI/LoadOverlay
var default_left_melody: String = "res://levels/melody1_left.txt"
@export_group("Just Can't Wait")
@export var song_1_title: String = "Just Can't Wait"
@export var song_1_path: String
@export var song_1_slow_song_path: String
@export var song_1_melody_path: String
@export var song_1_easy_path: String
@export var song_1_easy_slow_song_path: String
@export var song_1_easy_melody_path: String
@export var song_1_hard_melody_path: String
@export_group("Circle of Life")
@export var song_2_title: String = "Circle of Life"
@export var song_2_path: String
@export var song_2_slow_song_path: String
@export var song_2_melody_path: String
@export var song_2_easy_melody_path: String
@export var song_2_hard_melody_path: String
@export_group("Let it Go")
@export var song_3_title: String = "Let it Go"
@export var song_3_song_path: String
@export var song_3_slow_song_path: String
@export var song_3_melody_path: String
@export var song_3_hard_melody_path: String
@export_group("Hokey Pokey")
@export var song_4_title: String = "Hokey Pokey"
@export var song_4_song_path: String
@export var song_4_slow_song_path: String
@export var song_4_melody_path: String
@export var song_4_hard_melody_path: String
@export_group("Free Fallin")
@export var song_5_title: String = "Free Fallin"
@export var song_5_song_path: String
@export var song_5_slow_song_path: String
@export var song_5_melody_path: String
@export var song_5_hard_melody_path: String
@export_group("Dance Monkey")
@export var song_6_title: String = "Dance Monkey"
@export var song_6_song_path: String
@export var song_6_slow_song_path: String
@export var song_6_melody_path: String
@export var song_6_left_melody_path: String
@export var song_6_left_hard_melody_path: String
@export_group("Pokemon")
@export var song_7_title: String = "Pokemon"
@export var song_7_song_path: String
@export var song_7_slow_song_path: String
@export var song_7_melody_path: String
@export var song_7_left_melody_path: String
@export var song_7_left_hard_melody_path: String
@export_group("Believer")
@export var song_8_title: String = "Believer"
@export var song_8_song_path: String
@export var song_8_slow_song_path: String
@export var song_8_melody_path: String
@export var song_8_left_melody_path: String
@export_group("Jingle Bells")
@export var song_9_title: String = "Jingle Bells"
@export var song_9_song_path: String
@export var song_9_slow_song_path: String
@export var song_9_melody_path: String
@export var song_9_left_melody_path: String
@export var song_9_hard_melody_path: String
@export var song_9_left_hard_melody_path: String
@export_group("Let It March!")
@export var song_10_title: String = "Let It March!"
@export var song_10_song_path: String
@export var song_10_slow_song_path: String
@export var song_10_melody_path: String
@export var song_10_hard_melody_path: String
@export_group("I Just Can't Wait to be TECHNO")
@export var song_11_title: String = "I Just Can't Wait to be TECHNO"
@export var song_11_song_path: String
@export var song_11_slow_song_path: String
@export var song_11_melody_path: String
@export var song_11_hard_melody_path: String


var maximum_input_distance: float = 100
var current_press_position: Vector2

var girl_characters: bool = false

func _ready() -> void:
	
	set_default_visibility()
	connect_buttons()
	#auto_play_toggle.set_pressed_no_signal(Game.cheat_auto_play)
	#skip_intro.set_pressed_no_signal(Game.cheat_skip_intro)
	#skip_middle_c.set_pressed_no_signal(Game.cheat_skip_middle_c)
	
	
	debug_toggle.set_pressed_no_signal(Game.debug)
	#if Game.game_mode == "library":
		#library_song_toggle.set_pressed_no_signal(true)
	#else:
		#library_song_toggle.set_pressed_no_signal(false)
		
	apply_settings()

func set_default_visibility() -> void:
	dev_buttons.visible = true
	load_overlay.visible = false
	darken.visible = false

# Load and apply settings from the settings file
func apply_settings() -> void:
	# Apply settings to the UI and game
	debug_toggle.button_pressed = settings_manager.settings.get("debug_toggle", false)
	boss_toggle.button_pressed = settings_manager.settings.get("boss_toggle", false)
	auto_play_toggle.button_pressed = settings_manager.settings.get("auto_play_toggle", false)
	library_song_toggle.button_pressed = settings_manager.settings.get("library_song_toggle", false)
	skip_middle_c.button_pressed = settings_manager.settings.get("skip_middle_c", false)
	skip_intro.button_pressed = settings_manager.settings.get("skip_intro", false)
	show_library_toggle.button_pressed  = settings_manager.settings.get("show_library_toggle", false)
	sp_toggle.button_pressed  = settings_manager.settings.get("sp_toggle", false)
	new_stars_toggle.button_pressed  = settings_manager.settings.get("score_based_stars", false)
	play_piano_toggle.button_pressed  = settings_manager.settings.get("play_piano_sounds", false)
	#character_selection.selected = settings_manager.settings.get("character_selection", 0)
	#character_selection.emit_signal("item_selected",settings_manager.settings.get("character_selection", 0))
	girl_characters = settings_manager.settings.get("girl_characters", false)
	boy_girl_toggle.button_pressed = girl_characters
	if girl_characters:
		girl_selection.emit_signal("item_selected",girl_selection.get_selected_id())
	else:
		boy_selection.emit_signal("item_selected",boy_selection.get_selected_id())
	

func connect_buttons() -> void:	
	self.connect("close_requested", Callable(self, "_on_close_requested"))


func _on_close_requested() -> void:
	# Queue free to remove the window from the scene
	queue_free()
	
	
func start_level(type: String = "normal") -> void:
	Game.game_state = "Intro"
	Game.boss_model = "robot_"
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


func unpressed_accepted() -> bool:
	var current_unpressed_position: Vector2 = get_mouse_position()
	if current_unpressed_position.distance_to(current_press_position) > 300:
		return false
	else:
		return true

func _on_easy_button_button_up() -> void:
	Game.game_mode = "boss"
	start_level("easy")

func _on_normal_button_button_up() -> void:
	Game.game_mode = "boss"
	start_level("normal")


func _on_hard_button_button_up() -> void:
	Game.game_mode = "boss"
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


func get_input_press_position() -> void:
	current_press_position = get_mouse_position()


func _on_auto_play_toggle_toggled(toggled_on: bool) -> void:
	print("auto played toggled: " + str(toggled_on))
	Game.cheat_auto_play = toggled_on
	settings_manager.settings["auto_play_toggle"] = toggled_on
	settings_manager.save_settings()


func _on_library_song_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Game.game_mode = "library"
	else:
		Game.game_mode = "boss"
	settings_manager.settings["library_song_toggle"] = toggled_on
	settings_manager.save_settings()


func _on_debug_toggle_toggled(toggled_on: bool) -> void:
	Game.debug = toggled_on
	settings_manager.settings["debug_toggle"] = toggled_on
	settings_manager.save_settings()


func _on_skip_intro_toggled(toggled_on: bool) -> void:
	Game.cheat_skip_intro = toggled_on
	settings_manager.settings["skip_intro"] = toggled_on
	settings_manager.save_settings()


func _on_skip_middle_c_toggled(toggled_on: bool) -> void:
	Game.cheat_skip_middle_c = toggled_on
	settings_manager.settings["skip_middle_c"] = toggled_on
	settings_manager.save_settings()


func _on_boss_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Game.boss_model = "robot_"
	else:
		Game.boss_model = ""
	settings_manager.settings["boss_toggle"] = toggled_on
	settings_manager.save_settings()


func _on_show_library_toggle_toggled(toggled_on: bool) -> void:
	settings_manager.settings["show_library_toggle"] = toggled_on
	settings_manager.save_settings()
		

func choose_character(index: int) -> void:
	print("chose character!")
	match index:
		0:
			Game.player_model = "girl_"
			change_character_stats(1.3,1,true)
			print("chose girl")
		1:
			Game.player_model = "boy_"
			change_character_stats(1,1.2)
			print("chose boy")
		_:
			Game.player_model = "girl_"
			change_character_stats(1.3,1,true)
			print("chose default - girl")
	settings_manager.settings["character_selection"] = index
	#settings_manager.settings["character_attack_modifier"] = Game.character_attack_modifier
	#settings_manager.settings["character_health_modifier"] = Game.character_health_modifier
	settings_manager.save_settings()


func _on_character_selection_item_selected(index: int) -> void:
	choose_character(index)

func change_character_stats(attack_modifier: float, health_modifier: float, strong_attacks: bool = false) -> void:
	Game.character_attack_modifier = attack_modifier
	Game.character_health_modifier = health_modifier
	Game.strong_attacks = strong_attacks

func _on_sp_toggle_toggled(toggled_on: bool) -> void:
	settings_manager.settings["sp_toggle"] = toggled_on
	settings_manager.save_settings()
	Game.sp_mode = toggled_on


func _on_play_piano_toggled(toggled_on: bool) -> void:
	settings_manager.settings["play_piano_sounds"] = toggled_on
	settings_manager.save_settings()
	Game.cheat_play_piano_sounds = toggled_on


func _on_new_stars_toggled(toggled_on: bool) -> void:
	settings_manager.settings["score_based_stars"] = toggled_on
	settings_manager.save_settings()
	Game.score_based_stars = toggled_on


func _on_boy_girl_toggle_toggled(toggled_on: bool) -> void:
	girl_characters = toggled_on
	Game.girl_characters = toggled_on
	settings_manager.settings["girl_characters"] = toggled_on
	settings_manager.save_settings()
	update_character_options()

func update_character_options() -> void:
	if girl_characters:
		girl_selection.visible = true
		boy_selection.visible = false
		girl_selection.selected = girl_selection.get_selectable_item()
		choose_character(girl_selection.get_selected_id())
	else:
		girl_selection.visible = false
		boy_selection.visible = true
		boy_selection.selected = boy_selection.get_selectable_item()
		choose_character(boy_selection.get_selected_id())
