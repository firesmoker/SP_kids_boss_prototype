extends Node2D


@onready var load_overlay: TextureRect = $UI/LoadOverlay
var new_scene_source: PackedScene = preload("res://scenes/game.tscn")
@export_category("Easy")
@export var easy_song_path: String
@export var easy_slow_song_path: String
@export var easy_melody_path: String
@export_category("Normal")
@export var normal_song_path: String
@export var normal_slow_song_path: String
@export var normal_melody_path: String
@export_category("Hard")
@export var hard_song_path: String
@export var hard_slow_song_path: String
@export var hard_melody_path: String

func _ready() -> void:
	load_overlay.visible = false


func start_level(melody_path: String, song_path: String,
				slow_song_path: String, tempo: float,
				player_life: float, boss_life: float) -> void:
	load_overlay.visible = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.start()
	await timer.timeout
	Game.game_state = "Playing"
	Game.song_path = song_path
	Game.slow_song_path = slow_song_path
	Game.melody_path = melody_path
	Game.tempo = tempo
	Game.starting_player_health = player_life
	Game.starting_boss_health = boss_life
	var new_scene_source: PackedScene = load(Game.game_scene)
	get_tree().change_scene_to_packed(new_scene_source)


func _on_easy_button_button_up() -> void:
	start_level(easy_melody_path,easy_song_path,easy_slow_song_path, 76, 10, 32)


func _on_normal_button_button_up() -> void:
	start_level(normal_melody_path,normal_song_path,normal_slow_song_path,78, 5, 19)
	

func _on_hard_button_button_up() -> void:
	start_level(hard_melody_path,hard_song_path,hard_slow_song_path,106,7, 23)
