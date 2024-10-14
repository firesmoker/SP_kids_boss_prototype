extends Node2D

@onready var darken: TextureRect = $UI/Darken
@onready var difficulty: Panel = $UI/Difficulty
@onready var normal_button: Button = $UI/Difficulty/NormalButton
@onready var hard_button: Button = $UI/Difficulty/HardButton
@onready var song_buttons: ScrollContainer = $UI/SongButtons

var normal_melody_path: String
var normal_left_melody_path: String
var normal_song_path: String
var normal_slow_song_path: String
var normal_tempo: float
var normal_player_life: float
var normal_boss_life: float

var hard_melody_path: String
var hard_left_melody_path: String
var hard_song_path: String
var hard_slow_song_path: String
var hard_tempo: float
var hard_player_life: float
var hard_boss_life: float

@onready var load_overlay: TextureRect = $UI/LoadOverlay
var new_scene_source: PackedScene = preload("res://scenes/game.tscn")
@export_group("Just Can't Wait")
@export var song_1_path: String
@export var song_1_slow_song_path: String
@export var song_1_melody_path: String
@export_group("Circle of Life")
@export var song_2_path: String
@export var song_2_slow_song_path: String
@export var song_2_melody_path: String
@export_group("Let it Go")
@export var song_3_song_path: String
@export var song_3_slow_song_path: String
@export var song_3_melody_path: String
@export_group("Hokey Pokey")
@export var song_4_song_path: String
@export var song_4_slow_song_path: String
@export var song_4_melody_path: String
@export_group("Free Fallin")
@export var song_5_song_path: String
@export var song_5_slow_song_path: String
@export var song_5_melody_path: String
@export_group("Dance Monkey")
@export var song_6_song_path: String
@export var song_6_slow_song_path: String
@export var song_6_melody_path: String
@export var song_6_left_melody_path: String
@export_group("Pokemon")
@export var song_7_song_path: String
@export var song_7_slow_song_path: String
@export var song_7_melody_path: String
@export var song_7_left_melody_path: String
@export_group("Believer")
@export var song_8_song_path: String
@export var song_8_slow_song_path: String
@export var song_8_melody_path: String
@export var song_8_left_melody_path: String

func _ready() -> void:
	load_overlay.visible = false
	darken.visible = false
	difficulty.visible = false


func start_level(melody_path: String, left_melody_path: String, song_path: String,
				slow_song_path: String, tempo: float,
				player_life: float, boss_life: float) -> void:
	load_overlay.visible = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.start()
	await timer.timeout
	timer.stop()
	Game.game_state = "Playing"
	Game.song_path = song_path
	Game.slow_song_path = slow_song_path
	Game.right_melody_path = melody_path
	Game.left_melody_path = left_melody_path
	Game.tempo = tempo
	Game.starting_player_health = player_life
	Game.starting_boss_health = boss_life
	#var new_scene_source: PackedScene = load(Game.game_scene)
	get_tree().change_scene_to_packed(new_scene_source)


	


func _on_button1_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_1_melody_path,"res://levels/melody1_left.txt",song_1_path,song_1_slow_song_path, 76, 8, 29)
	define_hard_level(song_1_melody_path,"res://levels/melody1_left.txt",song_1_path,song_1_slow_song_path, 76, 8, 29)


func _on_button2_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_2_melody_path,"res://levels/melody1_left.txt",song_2_path,song_2_slow_song_path,78, 4, 15)
	define_hard_level(song_2_melody_path,"res://levels/melody1_left.txt",song_2_path,song_2_slow_song_path,78, 4, 15)


func _on_button3_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_3_melody_path,"res://levels/melody1_left.txt",song_3_song_path,song_3_slow_song_path,106,5, 20)
	define_hard_level(song_3_melody_path,"res://levels/melody1_left.txt",song_3_song_path,song_3_slow_song_path,106,5, 20)


func _on_button_4_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_4_melody_path,"res://levels/melody1_left.txt",song_4_song_path,song_4_slow_song_path,88,9,35)
	define_hard_level(song_4_melody_path,"res://levels/melody1_left.txt",song_4_song_path,song_4_slow_song_path,88,9,35)


func _on_button_5_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_5_melody_path,"res://levels/melody1_left.txt",song_5_song_path,song_5_slow_song_path,155,13, 51)
	define_hard_level(song_5_melody_path,"res://levels/melody1_left.txt",song_5_song_path,song_5_slow_song_path,155,13, 51)


func _on_button_6_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_6_melody_path,song_6_left_melody_path,song_6_song_path,song_6_slow_song_path,85,6, 23)
	define_hard_level(song_6_melody_path,song_6_left_melody_path,song_6_song_path,song_6_slow_song_path,85,6, 23)


func _on_button_7_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_7_melody_path,song_7_left_melody_path,song_7_song_path,song_7_slow_song_path,115,4, 23)
	define_hard_level(song_7_melody_path,song_7_left_melody_path,song_7_song_path,song_7_slow_song_path,115,4, 23)


func _on_button_8_button_up() -> void:
	show_difficulty_buttons()
	define_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23)
	define_hard_level(song_8_melody_path,song_8_left_melody_path,song_8_song_path,song_8_slow_song_path,110,4, 23)


func _on_normal_button_button_up() -> void:
	start_level(normal_melody_path,
	normal_left_melody_path,
	normal_song_path,
	normal_slow_song_path,
	normal_tempo,
	normal_player_life,
	normal_boss_life)


func _on_hard_button_button_up() -> void:
	start_level(hard_melody_path,
	hard_left_melody_path,
	hard_song_path,
	hard_slow_song_path,
	hard_tempo,
	hard_player_life,
	hard_boss_life)

func define_level(melody_path: String, left_melody_path: String, song_path: String,
				slow_song_path: String, tempo: float,
				player_life: float, boss_life: float) -> void:
	normal_melody_path = melody_path
	normal_left_melody_path = left_melody_path
	normal_song_path = song_path
	normal_slow_song_path = slow_song_path
	normal_tempo = tempo
	normal_player_life = player_life
	normal_boss_life = boss_life

func define_hard_level(melody_path: String, left_melody_path: String, song_path: String,
				slow_song_path: String, tempo: float,
				player_life: float, boss_life: float) -> void:
	hard_melody_path = melody_path
	hard_left_melody_path = left_melody_path
	hard_song_path = song_path
	hard_slow_song_path = slow_song_path
	hard_tempo = tempo
	hard_player_life = player_life
	hard_boss_life = boss_life

func show_difficulty_buttons() -> void:
	song_buttons.visible = false
	darken.visible = true
	difficulty.visible = true
