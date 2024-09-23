class_name Game extends Node2D

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ending_point: Node2D = $EndingPoint
@onready var notes_container: Sprite2D = $EndingPoint/NotesContainer
@onready var notes_detector: ShapeCast2D = $NotesDetector
@onready var collect_detector: ShapeCast2D = $CollectDetector
@onready var player_character: AnimatedSprite2D = $PlayerCharacter
@onready var boss: AnimatedSprite2D = $Boss
@onready var player_health_bar: ProgressBar = $UI/PlayerHealthBar
@onready var boss_health_bar: ProgressBar = $UI/BossHealthBar

static var game_scene: String = "res://scenes/game.tscn"
static var game_over_scene: String = "res://scenes/game_over_screen.tscn"

var PlayerHealth: float = 10
var BossHealth: float = 10
var DamageFromBoss: float = 1
var DamageFromPlayer: float = 1
var starting_position: Vector2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		music_player.pitch_scale += 0.2
	elif event.is_action_pressed("ui_down"):
		music_player.pitch_scale -= 0.2


func _ready() -> void:
	starting_position = ending_point.position
	music_player.play(100)
	pass # Replace with function body.


func _process(delta: float) -> void:
	#if not music_player.playing:
		#music_player.play(110)
	var stream: AudioStream = music_player.stream
	var song_length: float = stream.get_length()
	var normalized_song_position: float = music_player.get_playback_position() / song_length
	#print(normalized_song_position)
	
	ending_point.position.x = lerp(starting_position.x+6000,-200.0,normalized_song_position)


func _on_music_player_finished() -> void:
	print("finished!")
	lose()

func lose() -> void:
	print("you lost")
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
