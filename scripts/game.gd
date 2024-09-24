class_name Game extends Node2D

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ending_point: Node2D = $EndingPoint
@onready var notes_container: NotesContainer = $EndingPoint/NotesContainer
@onready var notes_detector: NotesDetector = $Parser/NotesDetector
@onready var collect_detector: ShapeCast2D = $Parser/CollectDetector
@onready var player_character: AnimatedSprite2D = $PlayerCharacter
@onready var boss: AnimatedSprite2D = $Boss
@onready var player_health_bar: ProgressBar = $UI/PlayerHealthBar
@onready var boss_health_bar: ProgressBar = $UI/BossHealthBar

static var game_scene: String = "res://scenes/game.tscn"
static var game_over_scene: String = "res://scenes/game_over_screen.tscn"
static var game_won_scene: String = "res://scenes/game_won_screen.tscn"

var player_health: float = 10
var BossHealth: float = 10
var DamageFromBoss: float = 1
var DamageFromPlayer: float = 1
var starting_position: Vector2
var vul_time: float = 2
var time_elapsed: float = 0
var vulnerable: bool = false
var note_play_position_x: float
var just_started: bool = true



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		music_player.pitch_scale += 0.2
	elif event.is_action_pressed("ui_down"):
		music_player.pitch_scale -= 0.2
	#if event.is_action_pressed("ui_accept"):
		#pass


func _ready() -> void:
	note_play_position_x = notes_detector.position.x
	print("note play position X is: " + str(note_play_position_x))
	starting_position = ending_point.position
	music_player.play()
	player_health_bar.max_value = player_health
	player_health_bar.value = player_health
	boss_health_bar.max_value = BossHealth
	boss_health_bar.value = BossHealth


func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed > vul_time:
		vulnerable = true
	var stream: AudioStream = music_player.stream
	var song_length: float = stream.get_length()
	var normalized_song_position: float = music_player.get_playback_position() / song_length
	ending_point.position.x = lerp(notes_container.get_size() -abs(note_play_position_x),note_play_position_x,normalized_song_position)
	if just_started:
		notes_detector.clear_notes()
		just_started = false
	#print(ending_point.position.x)


func _on_music_player_finished() -> void:
	print("finished!")
	#lose()

func lose() -> void:
	print("you lost")
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

func win() -> void:
	print("you lost")
	get_tree().change_scene_to_file("res://scenes/game_won_screen.tscn")


func _on_hit_zone_body_entered(body: CollisionObject2D) -> void:
	if vulnerable:
		player_health -= 5
		player_health_bar.value = player_health
	else:
		print("false hit")


func on_level_ready() -> void:
	print("level ready detected!")


func _on_notes_detector_body_entered(body: CollisionObject2D) -> void:
	pass
