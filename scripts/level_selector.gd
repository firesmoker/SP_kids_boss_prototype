class_name LevelSelector extends Node

static var new_scene_source: PackedScene = preload("res://scenes/game.tscn")

static var normal_melody_path: String
static var normal_left_melody_path: String
static var normal_song_path: String
static var normal_slow_song_path: String
static var normal_tempo: float
static var normal_player_life: float
static var normal_boss_life: float

static var hard_melody_path: String
static var hard_left_melody_path: String
static var hard_song_path: String
static var hard_slow_song_path: String
static var hard_tempo: float
static var hard_player_life: float
static var hard_boss_life: float

static func set_level(level: String = "normal") -> void:
	Game.game_state = "Playing"
	match level:
		"normal":
			Game.current_difficulty = "normal"
			Game.right_melody_path = normal_melody_path
			Game.left_melody_path = normal_left_melody_path
			Game.song_path = normal_song_path
			Game.slow_song_path = normal_slow_song_path
			Game.tempo = normal_tempo
			Game.starting_player_health = normal_player_life
			Game.starting_boss_health = normal_boss_life
		"hard":
			Game.current_difficulty = "hard"
			Game.right_melody_path = hard_melody_path
			Game.left_melody_path = hard_left_melody_path
			Game.song_path = hard_song_path
			Game.slow_song_path = hard_slow_song_path
			Game.tempo = hard_tempo
			Game.starting_player_health = hard_player_life
			Game.starting_boss_health = hard_boss_life
		_:
			print("wrong level type!")
