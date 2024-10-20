class_name LevelSelector extends Node

static var new_scene_source: PackedScene = preload("res://scenes/game.tscn")

static var easy_melody_path: String
static var easy_left_melody_path: String
static var easy_song_path: String
static var easy_slow_song_path: String
static var easy_tempo: float
static var easy_player_life: float
static var easy_boss_life: float
static var easy_ui_type: String

static var normal_melody_path: String
static var normal_left_melody_path: String
static var normal_song_path: String
static var normal_slow_song_path: String
static var normal_tempo: float
static var normal_player_life: float
static var normal_boss_life: float
static var normal_ui_type: String

static var hard_melody_path: String
static var hard_left_melody_path: String
static var hard_song_path: String
static var hard_slow_song_path: String
static var hard_tempo: float
static var hard_player_life: float
static var hard_boss_life: float
static var hard_ui_type: String

static func set_level(level: String = "normal") -> void:
	Game.game_state = "Playing"
	match level:
		"easy":
			Game.current_difficulty = "easy"
			Game.right_melody_path = easy_melody_path
			Game.left_melody_path = easy_left_melody_path
			Game.song_path = easy_song_path
			Game.slow_song_path = easy_slow_song_path
			Game.tempo = easy_tempo
			Game.starting_player_health = easy_player_life
			Game.starting_boss_health = easy_boss_life
			Game.ui_type = easy_ui_type
		"normal":
			Game.current_difficulty = "normal"
			Game.right_melody_path = normal_melody_path
			Game.left_melody_path = normal_left_melody_path
			Game.song_path = normal_song_path
			Game.slow_song_path = normal_slow_song_path
			Game.tempo = normal_tempo
			Game.starting_player_health = normal_player_life
			Game.starting_boss_health = normal_boss_life
			Game.ui_type = normal_ui_type
		"hard":
			Game.current_difficulty = "hard"
			Game.right_melody_path = hard_melody_path
			Game.left_melody_path = hard_left_melody_path
			Game.song_path = hard_song_path
			Game.slow_song_path = hard_slow_song_path
			Game.tempo = hard_tempo
			Game.starting_player_health = hard_player_life
			Game.starting_boss_health = hard_boss_life
			Game.ui_type = hard_ui_type
		_:
			print("wrong level type!")
