extends Window

@onready var darken: TextureRect = $UI/Darken
@onready var difficulty: Panel = $UI/Difficulty
@onready var easy_button: Button = $UI/Difficulty/EasyButton
#@onready var normal_button: Button = $UI/Difficulty/NormalButton
#@onready var hard_button: Button = $UI/Difficulty/HardButton
@onready var song_buttons: ScrollContainer = $UI/SongButtons
@onready var auto_play_toggle: CheckButton = $UI/DevButtons/AutoPlayToggle
@onready var library_song_toggle: CheckButton = $UI/DevButtons/LibrarySongToggle
@onready var debug_toggle: CheckButton = $UI/DevButtons/DebugToggle
@onready var skip_intro: CheckButton = $"UI/DevButtons/Skip Intro"
@onready var skip_middle_c: CheckButton = $UI/DevButtons/SkipMiddleC
@onready var dev_buttons: Control = $UI/DevButtons
@onready var song_title: Label = $UI/Difficulty/SongTitle
@onready var boss_toggle: CheckButton = $UI/DevButtons/BossToggle
@onready var settings_manager: SettingsManager = $SettingsManager
@onready var boss_songs: VBoxContainer = $UI/SongButtons/BossSongs
@onready var library_songs: VBoxContainer = $UI/SongButtons/LibrarySongs
@onready var show_library_toggle: CheckButton = $UI/DevButtons/ShowLibraryToggle
@onready var character_selection: OptionButton = $UI/DevButtons/CharacterSelection
@onready var sp_toggle: CheckButton = $UI/DevButtons/SPToggle


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
	boss_songs.visible = true
	library_songs.visible = false
	dev_buttons.visible = true
	load_overlay.visible = false
	darken.visible = false
	difficulty.visible = false

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
	character_selection.selected = settings_manager.settings.get("character_selection", 0)
	character_selection.emit_signal("item_selected",settings_manager.settings.get("character_selection", 0))
	

func connect_buttons() -> void:	
	var boss_songs_buttons: Array = boss_songs.get_children()
	for button: Button in boss_songs_buttons:
		button.connect("button_down", get_input_press_position)
		
	var library_song_buttons: Array = library_songs.get_children()
	for button: Button in library_song_buttons:
		button.connect("button_down", get_input_press_position)
		
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



func _on_button1_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons(true)
		Game.has_easy_difficulty = true
		song_title.text = song_1_title
		define_easy_level(song_1_easy_melody_path,default_left_melody,song_1_easy_path,song_1_easy_slow_song_path, 70, 6, 24,3, "treble")
		define_level(song_1_melody_path,default_left_melody,song_1_path,song_1_slow_song_path, 76, 8, 30,2.5, "treble")
		define_hard_level(song_1_hard_melody_path,default_left_melody,song_1_path,song_1_slow_song_path, 76, 6, 31, 2.5, "treble")


func _on_button2_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons(true)
		song_title.text = song_2_title
		Game.has_easy_difficulty = true
		define_level(song_2_melody_path,default_left_melody,song_2_path,song_2_slow_song_path,78, 7, 26,3.3, "treble")
		define_easy_level(song_2_easy_melody_path,default_left_melody,song_2_path,song_2_slow_song_path,78, 6, 22,3, "treble")
		define_hard_level(song_2_hard_melody_path,default_left_melody,song_2_path,song_2_slow_song_path,78, 6, 35,3, "treble") #39-8 -> 


func _on_button3_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		song_title.text = song_3_title
		Game.has_easy_difficulty = false
		define_level(song_3_melody_path,default_left_melody,song_3_song_path,song_3_slow_song_path,106,5, 20, 3)
		define_easy_level(song_3_melody_path,default_left_melody,song_3_song_path,song_3_slow_song_path,106,5, 20, 3)
		define_hard_level(song_3_hard_melody_path,default_left_melody,song_3_song_path,song_3_slow_song_path,106,6, 31, 3)


func _on_button_4_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		song_title.text = song_4_title
		Game.has_easy_difficulty = false
		define_level(song_4_melody_path,default_left_melody,song_4_song_path,song_4_slow_song_path,88,9,35)
		define_easy_level(song_4_melody_path,default_left_melody,song_4_song_path,song_4_slow_song_path,88,9,35)
		define_hard_level(song_4_hard_melody_path,default_left_melody,song_4_song_path,song_4_slow_song_path,88,8,40)


func _on_button_5_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		song_title.text = song_5_title
		Game.has_easy_difficulty = false
		define_level(song_5_melody_path,default_left_melody,song_5_song_path,song_5_slow_song_path,155,13, 51)
		define_easy_level(song_5_melody_path,default_left_melody,song_5_song_path,song_5_slow_song_path,155,13, 51)
		define_hard_level(song_5_hard_melody_path,default_left_melody,song_5_song_path,song_5_slow_song_path,155,13, 55)


func _on_button_6_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		song_title.text = song_6_title
		Game.has_easy_difficulty = false
		define_level(song_6_melody_path,song_6_left_melody_path,song_6_song_path,song_6_slow_song_path,85,6, 23,2.5, "both")
		define_easy_level(song_6_melody_path,song_6_left_melody_path,song_6_song_path,song_6_slow_song_path,85,6, 23,2.5, "both")
		define_hard_level(song_6_melody_path,song_6_left_hard_melody_path,song_6_song_path,song_6_slow_song_path,85,8, 33, 2.5, "both")


func _on_button_7_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		song_title.text = song_7_title
		Game.has_easy_difficulty = false
		define_level(song_7_melody_path,song_7_left_melody_path,song_7_song_path,song_7_slow_song_path,115,4, 23,2.5, "both")
		define_easy_level(song_7_melody_path,song_7_left_melody_path,song_7_song_path,song_7_slow_song_path,115,4, 23,2.5, "both")
		define_hard_level(song_7_melody_path,song_7_left_hard_melody_path,song_7_song_path,song_7_slow_song_path,115,6, 26, 2.5, "both")


func _on_button_8_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		song_title.text = song_8_title
		Game.has_easy_difficulty = false
		define_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23,2.5, "both")
		define_easy_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23,2.5, "both")
		define_hard_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23, 2.5, "both")

func _on_button_9_button_up() -> void:
	if unpressed_accepted():
		print("close!")
		show_difficulty_buttons()
		song_title.text = song_9_title
		Game.has_easy_difficulty = false
		define_level(song_9_melody_path,song_9_left_melody_path,song_9_song_path,song_9_slow_song_path,88,10, 38,2.5, "both")
		define_easy_level(song_9_melody_path,song_9_left_melody_path,song_9_song_path,song_9_slow_song_path,88,10, 38,2.5, "both")
		define_hard_level(song_9_hard_melody_path,song_9_left_hard_melody_path,song_9_song_path,song_9_slow_song_path,88,12, 47, 2.5, "both")

func _on_button10_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons()
		song_title.text = song_10_title
		Game.has_easy_difficulty = false
		define_level(song_10_melody_path,default_left_melody,song_10_song_path,song_10_slow_song_path,106,5, 20, 3)
		define_easy_level(song_10_melody_path,default_left_melody,song_10_song_path,song_10_slow_song_path,106,5, 20, 3)
		define_hard_level(song_10_hard_melody_path,default_left_melody,song_10_song_path,song_10_slow_song_path,106,6, 31, 3)		


func _on_button_11_button_up() -> void:
	if unpressed_accepted():
		show_difficulty_buttons(true)
		song_title.text = song_11_title
		Game.has_easy_difficulty = true
		define_easy_level(song_11_melody_path,default_left_melody,song_11_song_path,song_11_slow_song_path, 76, 8, 30,2.5, "treble")
		define_level(song_11_melody_path,default_left_melody,song_11_song_path,song_11_slow_song_path, 76, 8, 30,2.5, "treble")
		define_hard_level(song_11_hard_melody_path,default_left_melody,song_11_song_path,song_11_slow_song_path, 76, 6, 31, 2.5, "treble")

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

func show_difficulty_buttons(show_easy: bool = false) -> void:
	dev_buttons.visible = false
	if show_easy:
		easy_button.visible = true
	else:
		easy_button.visible = false
	song_buttons.visible = false
	darken.visible = true
	difficulty.visible = true

func hide_difficulty_buttons() -> void:
	dev_buttons.visible = true
	song_buttons.visible = true
	darken.visible = false
	difficulty.visible = false


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


func _on_darken_button_pressed() -> void:
	hide_difficulty_buttons()


func _on_boss_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Game.boss_model = "robot_"
		difficulty.find_child("Boss0").visible = false
		difficulty.find_child("Boss1").visible = true
	else:
		Game.boss_model = ""
		difficulty.find_child("Boss0").visible = true
		difficulty.find_child("Boss1").visible = false
	settings_manager.settings["boss_toggle"] = toggled_on
	settings_manager.save_settings()


func _on_show_library_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		boss_songs.visible = false
		library_songs.visible = true
	else:
		boss_songs.visible = true
		library_songs.visible = false
	settings_manager.settings["show_library_toggle"] = toggled_on
	settings_manager.save_settings()
		

func load_library_song(song_dictionary: Dictionary) -> void:
	song_title.text = song_dictionary.get("title") 
	LevelSelector.normal_melody_path = song_dictionary.get("right_melody_path", default_left_melody) 
	LevelSelector.normal_left_melody_path = song_dictionary.get("left_melody_path", default_left_melody)
	LevelSelector.normal_song_path = song_dictionary.get("audio_file_path")
	LevelSelector.normal_tempo = song_dictionary.get("tempo")
	LevelSelector.normal_ui_type = song_dictionary.get("ui_type", "both")
	LevelSelector.normal_display_duration = song_dictionary.get("on_display_duration", 2.5)
	#library_song_toggle.button_pressed = true
	Game.game_mode = "library"
	start_level("normal")


func _on_library_button_1_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.pokemon)


func _on_library_button_2_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.believer)


func _on_library_button_3_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.the_bare_necessities)


func _on_library_button_4_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.enemy_rh)


func _on_library_button_5_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.do_you_want_to_build_a_snowman)


func _on_library_button_6_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.dance_monkey)


func _on_library_button_7_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.safe_and_sound)


func _on_library_button_8_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.to_gun_anthem)


func _on_library_button_9_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.enemy_bh)


func _on_library_button_10_pressed() -> void:
	if unpressed_accepted():
		load_library_song(SongBank.ole_ole_ole_ole)


func _on_character_selection_item_selected(index: int) -> void:
	print("chose character!")
	match index:
		0:
			Game.player_model = ""
			difficulty.find_child("Character0").visible = true
			difficulty.find_child("Character1").visible = false
			difficulty.find_child("Character2").visible = false
		1:
			Game.player_model = "girl_"
			difficulty.find_child("Character0").visible = false
			difficulty.find_child("Character1").visible = true
			difficulty.find_child("Character2").visible = false
		2:
			Game.player_model = "boy_"
			difficulty.find_child("Character0").visible = false
			difficulty.find_child("Character1").visible = false
			difficulty.find_child("Character2").visible = true
		_:
			Game.player_model = ""
			difficulty.find_child("Character0").visible = true
			difficulty.find_child("Character1").visible = false
			difficulty.find_child("Character2").visible = false
	settings_manager.settings["character_selection"] = index
	settings_manager.save_settings()


func _on_sp_toggle_toggled(toggled_on: bool) -> void:
	settings_manager.settings["sp_toggle"] = toggled_on
	settings_manager.save_settings()
	Game.sp_mode = toggled_on
