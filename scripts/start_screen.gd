extends Node2D


@onready var load_overlay: TextureRect = $UI/LoadOverlay
var new_scene_source: PackedScene = preload("res://scenes/game.tscn")
@export_category("Just Can't Wait")
@export var song_1_path: String
@export var song_1_slow_song_path: String
@export var song_1_melody_path: String
@export_category("Circle of Life")
@export var song_2_path: String
@export var song_2_slow_song_path: String
@export var song_2_melody_path: String
@export_category("Let it Go")
@export var song_3_song_path: String
@export var song_3_slow_song_path: String
@export var song_3_melody_path: String
@export_category("Hokey Pokey")
@export var song_4_song_path: String
@export var song_4_slow_song_path: String
@export var song_4_melody_path: String
@export_category("Free Fallin")
@export var song_5_song_path: String
@export var song_5_slow_song_path: String
@export var song_5_melody_path: String
@export_category("Dance Monkey")
@export var song_6_song_path: String
@export var song_6_slow_song_path: String
@export var song_6_melody_path: String
@export var song_6_left_melody_path: String
@export_category("Pokemon")
@export var song_7_song_path: String
@export var song_7_slow_song_path: String
@export var song_7_melody_path: String

func _ready() -> void:
	load_overlay.visible = false


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
	start_level(song_1_melody_path,"res://levels/melody1_left.txt",song_1_path,song_1_slow_song_path, 76, 8, 29)


func _on_button2_button_up() -> void:
	start_level(song_2_melody_path,"res://levels/melody1_left.txt",song_2_path,song_2_slow_song_path,78, 4, 15)


func _on_button3_button_up() -> void:
	start_level(song_3_melody_path,"res://levels/melody1_left.txt",song_3_song_path,song_3_slow_song_path,106,5, 20)


func _on_button_4_button_up() -> void:
	start_level(song_4_melody_path,"res://levels/melody1_left.txt",song_4_song_path,song_4_slow_song_path,88,9,35)


func _on_button_5_button_up() -> void:
	start_level(song_5_melody_path,"res://levels/melody1_left.txt",song_5_song_path,song_5_slow_song_path,155,13, 51)


func _on_button_6_button_up() -> void:
	start_level(song_6_melody_path,song_6_left_melody_path,song_6_song_path,song_6_slow_song_path,85,13, 51)


func _on_button_7_button_up() -> void:
	pass # Replace with function body.
