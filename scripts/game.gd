class_name Game extends Node2D

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var parser: Parser = $Parser
@onready var player_character: AnimatedSprite2D = $Level/PlayerCharacter
@onready var boss: AnimatedSprite2D = $Level/Boss
@onready var player_health_bar: ProgressBar = $UI/PlayerHealthBar
@onready var boss_health_bar: ProgressBar = $UI/BossHealthBar
@onready var level: Node2D = $Level
@onready var electric_beam: Sprite2D = $Level/RightHandPart/ElectricBeam

@onready var ending_point: Node2D = $Level/RightHandPart/EndingPoint
@onready var notes_container: NotesContainer = $Level/RightHandPart/EndingPoint/NotesContainer
@onready var notes_detector: NotesDetector = $Level/RightHandPart/NotesDetector
@onready var bottom_notes_detector: NotesDetector = $Level/RightHandPart/BottomNotesDetector


static var game_scene: String = "res://scenes/game.tscn"
static var game_over_scene: String = "res://scenes/game_over_screen.tscn"
static var game_won_scene: String = "res://scenes/game_won_screen.tscn"
static var game_state: String = "Playing"


@export_enum("treble","bass","both") var ui_type: String = "treble"
@export var tempo: float = 122.0
var level_length_in_bar: float = 0
var player_health: float = 10
var boss_health: float = 10
var DamageFromBoss: float = 1
var DamageFromPlayer: float = 1
var starting_position: Vector2
var vul_time: float = 2
var time_elapsed: float = 0
var vulnerable: bool = false
var note_play_position_x: float
var just_started: bool = true
var detector_position_x: float = -200

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		music_player.pitch_scale += 0.2
	elif event.is_action_pressed("ui_down"):
		music_player.pitch_scale -= 0.2
	#if event.is_action_pressed("ui_accept"):
		#pass


func _ready() -> void:
	initialize_part()
	level.position = Vector2(0,0)
	reset_health_bars()
	music_player.play()
	detector_position_x = notes_detector.position.x

func initialize_part(hand_parts: String = ui_type) -> void:
	if hand_parts.to_lower() == "treble" or hand_parts.to_lower() == "both":
		note_play_position_x = notes_detector.position.x
		starting_position = ending_point.position
		notes_container.construct_level(true, parser.get_melody_array_by_file("res://levels/melody1.txt"),
										parser.get_melody_array_by_file("res://levels/melody1_left.txt"))

func _process(delta: float) -> void:
	if not boss.is_playing():
		boss.play("idle")
	if not player_character.is_playing():
		player_character.play("idle")
	time_elapsed += delta
	if time_elapsed > vul_time:
		vulnerable = true
		
	var stream: AudioStream = music_player.stream
	var song_length: float = stream.get_length()
	
	level_length_in_bar = notes_container.level_length_in_bars
	song_length = (60.0 / tempo) * 4.0 * level_length_in_bar
	
	var normalized_song_position: float = music_player.get_playback_position() / song_length
	var starting_position_x: float = notes_container.get_size() -abs(note_play_position_x)
	ending_point.position.x = lerp(starting_position_x,note_play_position_x,normalized_song_position)
	if ending_point.position.x <= note_play_position_x:
		print("finished level")
		lose()
	if just_started:
		notes_detector.clear_notes()
		bottom_notes_detector.clear_notes()
		just_started = false


func _on_music_player_finished() -> void:
	print("finished!")
	lose()

func lose() -> void:
	print("you lost")
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

func win() -> void:
	game_state = "Win"
	print("you lost")
	get_tree().change_scene_to_file("res://scenes/game_won_screen.tscn")


func _on_hit_zone_body_entered(note: Note) -> void:
	if note.state == "Active":
		get_hit()
	else:
		print("not active, not interesting")


func hit_boss() -> void:
	electric_beam.find_child("Flash").flash()
	player_character.stop()
	player_character.play("attack")
	boss.find_child("Flash").flash(Color.RED)
	boss_health -= 1
	boss_health_bar.value = boss_health
	boss.play("get_hit")
	if boss_health <= 0:
		win()

func get_hit() -> void:
	if vulnerable:
		player_character.find_child("Flash").flash(Color.RED)
		player_health -= 1
		player_health_bar.value = player_health
	else:
		print("false hit")

func reset_health_bars() -> void:
	player_health_bar.max_value = player_health
	player_health_bar.value = player_health
	boss_health_bar.max_value = boss_health
	boss_health_bar.value = boss_health


func _on_boss_hit_zone_body_entered(note: Note) -> void:
	if note.state.to_lower() != "rest":
		boss.play("attack")
