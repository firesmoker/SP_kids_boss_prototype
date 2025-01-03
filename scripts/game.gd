class_name Game extends Node2D


var model: Dictionary

@export var level2_color: Color
@export var level3_color: Color
@export var level4_color: Color

@onready var lib_visuals: Node2D = $Level/LibVisuals
@onready var character: Sprite2D = $Level/LibVisuals/Character
@onready var top_staff_power: Sprite2D = $Level/RightHandPart/UpperStaff/UpperStaffSprite/StaffPower
@onready var top_staff_power_lower: Sprite2D = $Level/RightHandPart/UpperStaff/UpperStaffSprite/StaffPowerLower
@onready var music_ending_player: AudioStreamPlayer = $Sound/MusicEndingPlayer
@onready var top_upper_glow: AnimatedSprite2D = $Level/RightHandPart/UpperStaff/UpperGlow
@onready var top_bottom_glow: AnimatedSprite2D = $Level/RightHandPart/UpperStaff/BottomGlow
@onready var bottom_upper_glow: AnimatedSprite2D = $Level/RightHandPart/BottomStaff/BottomStaffSprite/UpperGlow
@onready var bottom_bottom_glow: AnimatedSprite2D = $Level/RightHandPart/BottomStaff/BottomStaffSprite/BottomGlow
@onready var golden_meter: Label = $UI/StarsPanel/Panel/GoldenMeter
@onready var golden_note: TextureRect = $UI/StarsPanel/Panel/GoldenNote

	
@onready var bottom_staff_power: Sprite2D = $Level/RightHandPart/BottomStaff/BottomStaffSprite/StaffPower


@onready var video_layer_1: VideoStreamPlayer = $VideoCanvas/VideoLayer1
@onready var video_layer_2: VideoStreamPlayer = $VideoCanvas/VideoLayer2
@onready var video_layer_3: VideoStreamPlayer = $VideoCanvas/VideoLayer3
@onready var video_layer_4: VideoStreamPlayer = $VideoCanvas/VideoLayer4
@onready var video_layer_5: VideoStreamPlayer = $VideoCanvas/VideoLayer5
@onready var stars_panel: Control = $UI/StarsPanel
@onready var star_bar: TextureProgressBar = $UI/StarsPanel/StarBar
@export var score_success_color: Color
@onready var star_celebration: AspectRatioContainer = $UI/StarCelebration
@onready var confetti: AnimatedSprite2D = $Level/LibVisuals/Confetti
@onready var player_name_label: Label = $UI/PlayerPanel/Name

static var boss_id:String
static var boss_name:String = "בוס"
static var player_name:String = "שחקן"

var star1_threshold_modifier: float = 0.5
var star2_threshold_modifier: float = 0.7
var star3_threshold_modifier: float = 0.9

static var star1_threshold_score: float
static var star2_threshold_score: float
static var star3_threshold_score: float

static var score_based_stars: bool = false

static var golden_note_value: float = 1

static var strong_attacks: bool = false
static var bigger_health: bool = false

static var last_menu: String = "journey"

var star1_unlocked: bool = false
var star2_unlocked: bool = false
var star3_unlocked: bool = false

static var golden_notes_collected: int = 0

var fade_right_hand_part: bool = false

static var song_results: Dictionary

@onready var white_layer_4: TextureRect = $UI/WhiteLayer4

@onready var single_glow: Sprite2D = $Level/RightHandPart/CollectDetect/BlueLine/SingleLine/Glow
@onready var multi_glow: Sprite2D = $Level/RightHandPart/CollectDetect/BlueLine/MultiLine/Glow

static var target_xp: int = 100  # Replace with your desired XP value
@onready var xp: Node = $Overlay/XP
@onready var xp_label: Label = $Overlay/XP/XPLabel
@onready var xp_audio_player: AudioStreamPlayer = $Overlay/XP/XPAudioPlayer
@onready var stars_audio_player: AudioStreamPlayer = $Overlay/Stars/StarsAudioPlayer
@onready var star1: AnimatedSprite2D = $Overlay/Stars/Star1
@onready var star2: AnimatedSprite2D = $Overlay/Stars/Star2
@onready var star3: AnimatedSprite2D = $Overlay/Stars/Star3
@onready var stars: Control = $Overlay/Stars
@onready var difficulty: Panel = $Overlay/Difficulty
@onready var easy_button: Button = $Overlay/Difficulty/EasyButton
#@onready var intro_sequence: AnimatedSprite2D = $CameraOverlay/AspectRatioContainer/IntroSequence
@onready var intro_sequence_transition: AnimatedSprite2D = $CameraOverlay/AspectRatioContainer/IntroSequenceTransition

@onready var intro_sequence: VideoStreamPlayer = $BossVideoCanvas/IntroSequence

@onready var score_meter: Label = $UI/StarsPanel/Panel/ScoreMeter
@onready var combo_meter: Control = $UI/StarsPanel/Panel/ComboMeter
@onready var combo_animation: AnimatedSprite2D = $UI/StarsPanel/Panel/ComboMeter/ComboAnimation
@onready var combo_audio_player: AudioStreamPlayer = $UI/StarsPanel/Panel/ComboMeter/ComboAudioPlayer
@onready var combo_feedback_animation: AnimatedSprite2D = $Level/RightHandPart/ComboFeedbackAnimation

@onready var debug_window: Control = $Overlay/DebugWindow
@onready var debug_missed_notes: Label = $Overlay/DebugWindow/DebugMissedNotes
@onready var debug_notes_in_level: Label = $Overlay/DebugWindow/DebugNotesInLevel
@onready var debug_gamified_score: Label = $Overlay/DebugWindow/DebugGamifiedScore
@onready var debug_overall_score: Label = $Overlay/DebugWindow/DebugOverallScore
@onready var debug_vulnerable: Label = $Overlay/DebugWindow/DebugVulnerable
@onready var debug_perfect_score: Label = $Overlay/DebugWindow/DebugPerfectScore
@onready var debug_difficulty: Label = $Overlay/DebugWindow/DebugDifficulty


@onready var continue_note_popup: TextureRect = $Overlay/ContinueNotePopup
@onready var combo_tutorial_popup: TextureRect = $Overlay/ComboTutorialPopup


@onready var blue_line: Node2D = $Level/RightHandPart/CollectDetect/BlueLine
@onready var player_platform: Node2D = $Level/PlayerPlatform
@onready var boss_platform: Node2D = $Level/BossPlatform


@onready var audio: AudioStreamPlayer = $Sound/Audio
@onready var audio_clips: AudioClips = $Sound/AudioClips
@onready var music_player: AudioStreamPlayer = $Sound/MusicPlayer
@onready var music_player_slow: AudioStreamPlayer = $Sound/MusicPlayerSlow

@onready var parser: Parser = $Parser
@onready var player_character: AnimatedSprite2D = $Level/PlayerCharacter
@onready var player_bot: AnimatedSprite2D = $Level/PlayerBot
@onready var darken: TextureRect = $Overlay/Darken
@onready var darken_level: TextureRect = $UI/DarkenLevel
@onready var tutorial: Panel = $Overlay/Tutorial
@onready var tutorial_text: Label = $Overlay/Tutorial/Text
@onready var win_buttons: Panel = $Overlay/WinButtons
@onready var player_portrait: TextureRect = $UI/PlayerPanel/PlayerPortrait
@onready var player_panel: TextureRect = $UI/PlayerPanel
@onready var boss_panel: TextureRect = $UI/BossPanel
@onready var boss_label: Label = $UI/BossPanel/Label

@onready var boss_portrait: TextureRect = $UI/BossPanel/BossPortrait

@onready var popup_progress_bar: PopupProgressBar = $Overlay/Tutorial/ProgressBar

@onready var return_button: TextureButton = $Overlay/Return

@onready var into_stage: AnimatedSprite2D = $Level/IntoStage
@onready var win_text: Label = $Overlay/WinText
@onready var lose_text: Label = $Overlay/LoseText

@onready var boss: AnimatedSprite2D = $Level/Boss
@onready var player_health_bar: TextureProgressBar = $UI/PlayerHealthBar
@onready var player_health_bar_long: TextureProgressBar = $UI/PlayerHealthBarLong
@onready var player_health_bar_fake: TextureProgressBar = $UI/PlayerHealthBarFake


@onready var boss_health_bar: TextureProgressBar = $UI/BossHealthBar
@onready var level: Node2D = $Level
@onready var detector_visual: Node2D = $Level/DetectorVisual

@onready var electric_beam: Sprite2D = $Level/DetectorVisual/ElectricBeam
@onready var vignette: Sprite2D = $Level/Vignette
@onready var background: TextureRect = $UI/Background
@onready var background_slow: TextureRect = $UI/BackgroundSlow
@onready var background_library: TextureRect = $UI/BackgroundLibrary
@onready var background_library_solid: TextureRect = $UI/BackgroundLibrarySolid

@onready var background_sp: TextureRect = $UI/BackgroundSP

@onready var pause_button: TextureButton = $Overlay/Pause
@onready var restart_button: TextureButton = $Overlay/Restart

@onready var right_hand_part: Node2D = $Level/RightHandPart
@onready var bottom_staff: Node2D = $Level/RightHandPart/BottomStaff


@onready var ending_point: Node2D = $Level/RightHandPart/EndingPoint
@onready var notes_container: NotesContainer = $Level/RightHandPart/EndingPoint/NotesContainer
@onready var notes_detector: NotesDetector = $Level/RightHandPart/NotesDetector
@onready var bottom_notes_detector: NotesDetector = $Level/RightHandPart/BottomNotesDetector

@onready var score_manager: ScoreManager = $ScoreManager

@export var accelerate_sound: AudioStream
@export var slow_down_sound: AudioStream

static var heart_healing_bonus: float = 0
static var song_title: String = ""
static var boss_model: String = "boss_meta_golem"
static var player_model: String = "boy_meta_echo"
static var gender: String = "boy"
static var current_difficulty: String
static var has_easy_difficulty: bool = false
static var song_id: String = ""
static var song_path: String = "res://audio/CountingStars_122bpm_new.ogg"
static var slow_song_path: String = "res://audio/CountingStars_122bpm_new_SLOW80.ogg"
static var right_melody_path: String = "res://levels/IJustCantWaitToBeKing_76_Right.txt"
static var left_melody_path: String = "res://levels/IJustCantWaitToBeKing_76_Right.txt"
static var game_scene: String = "res://scenes/game.tscn"
static var game_over_scene: String = "res://scenes/game_over_screen.tscn"
static var game_won_scene: String = "res://scenes/journey_screen.tscn"
static var game_state: String
static var health_collected: bool = false
static var slowdown_collected: bool = false
static var bomb_collected: bool = false
static var tempo: float = 122.0
static var starting_player_health: float = 10
static var starting_boss_health: float = 300
static var ui_type: String = "treble" # treble / bass / both
static var repeat_requested: bool = false
static var last_game_lost: bool = false
static var on_display_duration: float = 1
static var cheat_auto_play: bool = false
static var cheat_skip_intro: bool = false
static var cheat_skip_middle_c: bool = false
static var cheat_play_piano_sounds: bool = false
static var game_mode: String = "boss"
static var debug: bool = false
static var construction_complete: bool = false
static var ending_music_path: String

var player_health: float = 10
var boss_health: float = 300
var original_health_color: Color = Color.WHITE

var threshold1_unlocked: bool = false
var threshold2_unlocked: bool = false
var threshold3_unlocked: bool = false

@export var slow_down_percentage: float = 0.7
@export var slow_timer: float = 10.5
var level_length_in_bar: float = 0
@export var health_rate: float = 1

static var character_attack_modifier: float = 1
static var character_health_modifier: float = 1
static var character_extended_healthbar: bool = false

var starting_position: Vector2
var vul_time: float = 2
var time_elapsed: float = 0
var vulnerable: bool = false
var note_play_position_x: float
var just_started: bool = true
var slow_down: bool = false
var detector_position_x: float = -200
var winning: bool = false
var losing: bool = false
var fading_music: bool = false
var player_moving_to_finish: bool = false
var player_new_health: float = 0
var player_previous_health: float = 0
var player_health_progress: float = 0
var boss_new_health: float = 0
var boss_previous_health: float = 0
var boss_health_progress: float = 0
var got_hit_atleast_once: bool = false
var missed_notes: int = 0
static var tutorial_closed: bool = false
var continue_note_played: bool = false
static var level_ready: bool = false
var grace_period_finished: bool = false
var score_visual_time: float = 0.6
var current_score_visual_time: float = 1

var music_fade_in_amount: float = 25
var music_fade_out_amount: float = 2

var beats_before_ending_music: float = 1
var beats_before_ending_music_counter: float = 0

var played_ending_music: bool = false

static var sp_mode: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		#level_accelerate()
		restart_level()
	elif event.is_action_pressed("ui_down"):
		level_slow_down()
	elif event.is_action_pressed("ui_right"):
		if not slow_down:
			music_player.seek(music_player.get_playback_position() + 0.5)
		else:
			music_player_slow.seek(music_player_slow.get_playback_position() + 0.5)
	elif event.is_action_pressed("ui_left"):
		if not slow_down:
			music_player.seek(music_player.get_playback_position() - 0.5)
		else:
			music_player_slow.seek(music_player_slow.get_playback_position() - 0.5)



func pause(darken_on_pause: bool = false, darken_level_on_pause: bool = false) -> void:
	if not get_tree().paused:
		#pause_button.text = "Resume"
		return_button.visible = true
		print("PAUSING!")
		if darken_on_pause:
			darken.visible = true
		if darken_level_on_pause:
			darken_level.visible = true
		get_tree().paused = true
	else:
		return_button.visible = false
		#pause_button.text = "Pause"
		print("OH YEAH")
		darken.visible = false
		darken_level.visible = false
		get_tree().paused = false


func set_stars_visibility() -> void:
	star_bar.find_child("easy").visible = false
	star_bar.find_child("medium").visible = false
	star_bar.find_child("hard").visible = false
	star_bar.find_child(current_difficulty).visible = true


func level_accelerate() -> void:
	if slow_down != false:
		background.visible = true
		background_slow.visible = false
		audio.stream = accelerate_sound
		audio.play()
		slow_down = false
		music_player.play(music_player_slow.get_playback_position() * slow_down_percentage)
		music_player_slow.stop()
		vignette.find_child("Fader").fade_out()

func level_slow_down(timed: bool = true, wait_time: float = slow_timer) -> void:
	if slow_down != true:
		background.visible = false
		background_slow.visible = true
		audio.stream = slow_down_sound
		audio.play()
		slow_down = true
		music_player_slow.play(music_player.get_playback_position() * (1 / slow_down_percentage))
		music_player.stop()
		vignette.find_child("Fader").fade_in()
		if timed:
			var timer: Timer = Timer.new()
			add_child(timer)
			timer.wait_time = wait_time
			timer.start()
			await timer.timeout
			level_accelerate()


func complete_disable(nodes: Array[Node2D]) -> void:
	for node in nodes:
		node.visible = false
		node.process_mode = Node.PROCESS_MODE_DISABLED

func complete_enable(nodes: Array[Node2D]) -> void:
	for node in nodes:
		node.visible = true
		node.process_mode = Node.PROCESS_MODE_INHERIT


func set_default_visibility() -> void:
	## Generic visuals:
	right_hand_part.position = Vector2(-52.032,-120.794)
	darken_level.visible = false
	continue_note_popup.visible = false
	return_button.visible = false
	background_slow.visible = false
	intro_sequence_transition.visible = false
	into_stage.frame = 0
	into_stage.visible = false
	win_buttons.visible = false
	win_text.visible = false
	win_text.modulate.a = 0
	
	## Hide Library visuals:
	set_library_song_visibility(false)
	
	## Hide Boss visuals:
	set_boss_visibility(false)

func set_library_song_visibility(toggle: bool = true) -> void:
	if toggle == true:
		right_hand_part.position.y -= 0
	lib_visuals.visible = toggle
	star_bar.visible = toggle
	set_star_bar_color()
	stars_panel.visible = toggle
	score_meter.visible = false
	video_layer_1.visible = toggle
	background_sp.visible = toggle
	video_layer_2.visible = false
	video_layer_3.visible = false
	video_layer_4.visible = false
	video_layer_5.visible = false
	white_layer_4.visible = false
	background_library.visible = false
	background_library_solid.visible = false
	#background_sp.visible = false
	combo_feedback_animation.visible = false
	top_upper_glow.visible = false
	bottom_upper_glow.visible = false
	top_bottom_glow.visible = false
	bottom_bottom_glow.visible = false
	combo_meter.visible = false
	if not tutorial_closed:
		combo_tutorial_popup.visible = false
	else:
		combo_tutorial_popup.visible = false
	set_stars_visibility()
	
	if sp_mode:
		print("SP MODE!")
		lib_visuals.visible = false
		background_library_solid.visible = false
		star_bar.visible = false
		score_meter.visible = false
		stars_panel.visible = false
		background_library.visible = false
		background_sp.visible = true

func set_star_bar_color() -> void:
	match current_difficulty:
		"easy":
			star_bar.tint_progress = Color(0.914,0.416,0.267)
		"medium":
			star_bar.tint_progress = Color(0.792,0.82,0.863)
		"hard":
			star_bar.tint_progress = Color(1,0.875,0.384)
		_:
			star_bar.tint_progress = Color.BLUE

func set_boss_visibility(toggle: bool = true) -> void:
	if ui_type == "both":
		right_hand_part.position.y += 20
	boss.visible = toggle
	if bigger_health:
		player_health_bar_long.visible = toggle
		player_health_bar.visible = false
	else:
		player_health_bar_long.visible = false
		player_health_bar.visible = toggle
	#player_health_bar_long.visible = false
	#player_health_bar.visible = toggle
	player_health_bar_fake.visible = toggle
	boss_health_bar.visible = toggle
	player_character.visible = toggle
	player_bot.visible = false
	background.visible = toggle
	background_slow.visible = false
	intro_sequence.visible = false
	blue_line.find_child("SingleLine").find_child("LineZapSingle").visible = toggle
	blue_line.find_child("MultiLine").find_child("LineZapMulti").visible = toggle
	#electric_beam.find_child("LineZapMulti").visible = toggle
	#electric_beam.find_child("ElectricBolt").visible = toggle
	player_panel.visible = toggle
	boss_panel.visible = toggle
	player_platform.visible = toggle
	boss_platform.visible = toggle
	white_layer_4.visible = false
	
	if strong_attacks:	
		top_staff_power.scale.y *= 1.1
		top_staff_power_lower.scale.y *= 1.1
		bottom_staff_power.scale.y *= 1.1
		
		top_staff_power.self_modulate = Color.HOT_PINK
		top_staff_power_lower.self_modulate = Color.HOT_PINK
		bottom_staff_power.self_modulate = Color.HOT_PINK
		
		top_staff_power.position.y -= 3
		top_staff_power_lower.position.y -= 3
		bottom_staff_power.position.y += 3
	
	
	if not cheat_skip_intro and not last_game_lost:
		intro_sequence.visible = toggle


func set_star_bar_values() -> void:
	#star_bar.max_value = notes_container.notes_in_level - 1
	
	star_bar.max_value = 1
	print("star bar max value = " + str(star_bar.max_value))
	print("notes in level = " + str(notes_container.notes_in_level))
	star_bar.value = 0
	star1_threshold_score = star_bar.max_value * star1_threshold_modifier
	star2_threshold_score = star_bar.max_value * star2_threshold_modifier
	star3_threshold_score = star_bar.max_value * star3_threshold_modifier
	
	score_manager.combo_full_hits = roundi(score_manager.total_notes_in_level / 6)
	score_manager.perfect_score = score_manager.perfect_score_in_level()
	score_manager.three_stars_score = score_manager.three_stars_score_in_level()
	star3_threshold_score = score_manager.three_stars_score / score_manager.perfect_score * star3_threshold_modifier
	star2_threshold_score = star3_threshold_score * star2_threshold_modifier
	star1_threshold_score = star3_threshold_score * star1_threshold_modifier
	print("star 3 threshold is: " + str(star3_threshold_score))
	print("star 2 threshold is: " + str(star2_threshold_score))
	print("star 1 threshold is: " + str(star1_threshold_score))
	
	var cuurent_difficulty_stars: Control = star_bar.find_child(current_difficulty)
	
	var star1: TextureRect = cuurent_difficulty_stars.find_child("Star1")
	var star2: TextureRect = cuurent_difficulty_stars.find_child("Star2")
	var star3: TextureRect = cuurent_difficulty_stars.find_child("Star3")
	
	if score_based_stars:
		star1.position.x = -star1.size.x/2 + star_bar.size.x * 0.4
		star2.position.x = -star2.size.x/2 + star_bar.size.x * 0.6
		star3.position.x = -star2.size.x/2 + star_bar.size.x * 0.8
	else:
		star1.position.x = -star1.size.x/2 + star_bar.size.x * star1_threshold_modifier
		star2.position.x = -star2.size.x/2 + star_bar.size.x * star2_threshold_modifier
		star3.position.x = -star2.size.x/2 + star_bar.size.x * star3_threshold_modifier

func update_golden_meter(delta:float = 0.01666666666667) -> void:
	golden_meter.text = (str(golden_notes_collected) + " / " + str(notes_container.golden_notes_in_level))
	if current_score_visual_time < score_visual_time:
		current_score_visual_time += delta * 2.3
		golden_meter.self_modulate = lerp(Color.WHITE,score_success_color, clamp(current_score_visual_time/score_visual_time,0,1))
	else:
		current_score_visual_time += delta * 2.3
		golden_meter.self_modulate = lerp(score_success_color,Color.WHITE, clamp((current_score_visual_time-score_visual_time)/score_visual_time,0,1))
	
	

func update_ingame_stars() -> void:
	var star3_condition: bool = false
	var star2_condition: bool = false
	var star1_condition: bool = false
	
	var current_difficulty_stars: Control = star_bar.find_child(current_difficulty)
	
	if score_based_stars:
		star_bar.value = score_manager.gamified_overall_score
		if score_manager.gamified_overall_score > star3_threshold_score:
			star3_condition = true
		elif score_manager.gamified_overall_score > star2_threshold_score:
			star2_condition = true
		elif score_manager.gamified_overall_score > star1_threshold_score:
			star1_condition = true
		
	else:
		star_bar.value = score_manager.overall_score
		if score_manager.overall_score > star3_threshold_modifier:
			star3_condition = true
		elif score_manager.overall_score > star2_threshold_modifier:
			star2_condition = true
		elif score_manager.overall_score > star1_threshold_modifier:
			star1_condition = true
		
	#if star3_unlocked and video_layer_4.modulate.a >= 1:
		#video_layer_3.process_mode = Node.PROCESS_MODE_DISABLED
		#print("video 3 disabled")
	#elif star2_unlocked and video_layer_3.modulate.a >= 1:
		#video_layer_2.process_mode = Node.PROCESS_MODE_DISABLED
		#print("video 2 disabled")
	#elif star1_unlocked and video_layer_2.modulate.a >= 1:
		#print("video 1 disabled")
		#video_layer_1.process_mode = Node.PROCESS_MODE_DISABLED
	
	
	
		
	if star3_condition:
		#video_layer_4.process_mode = Node.PROCESS_MODE_INHERIT
		#video_layer_4.find_child("Fader").fade_in(0.015)
		current_difficulty_stars.find_child("Star3").find_child("TurnedOn").visible = true
		if not star3_unlocked:
			confetti.process_mode = Node.PROCESS_MODE_INHERIT
			confetti.frame = 0
			confetti.play()
			audio.stream = audio_clips.star
			audio.play()
			star3_unlocked = true
			var expander: Expander = current_difficulty_stars.find_child("Star3").find_child("Expander")
			expander.expand(1.7,0.25,true)
	elif star2_condition:
		#video_layer_3.process_mode = Node.PROCESS_MODE_INHERIT
		#video_layer_3.find_child("Fader").fade_in(0.015)
		current_difficulty_stars.find_child("Star2").find_child("TurnedOn").visible = true
		if not star2_unlocked:
			confetti.process_mode = Node.PROCESS_MODE_INHERIT
			confetti.frame = 0
			confetti.play()
			audio.stream = audio_clips.star
			audio.play()
			star2_unlocked = true
			var expander: Expander = current_difficulty_stars.find_child("Star2").find_child("Expander")
			expander.expand(1.7,0.25,true)
	elif star1_condition:
		#video_layer_2.process_mode = Node.PROCESS_MODE_INHERIT
		#video_layer_2.find_child("Fader").fade_in(0.015)
		current_difficulty_stars.find_child("Star1").find_child("TurnedOn").visible = true
		if not star1_unlocked:
			confetti.process_mode = Node.PROCESS_MODE_INHERIT
			confetti.frame = 0
			confetti.play()
			audio.stream = audio_clips.star
			audio.play()
			star1_unlocked = true
			var expander: Expander = current_difficulty_stars.find_child("Star1").find_child("Expander")
			expander.expand(1.7,0.25,true)

func set_player_health() -> void:
	original_health_color = player_health_bar.tint_progress
	player_health = starting_player_health
	print("player health function")
	#if not bigger_health:
		#print("not bigger health!")
		#player_health_bar.max_value = player_health * 1.2
	#else:
		#player_health_bar.max_value = player_health
	player_health_bar.max_value = player_health
	player_health_bar.value = player_health
	player_health_bar_long.max_value = player_health
	player_health_bar_long.value = player_health
	
	

func set_boss_health() -> void:
	boss_health = starting_boss_health
	boss_health_bar.max_value = boss_health
	boss_health_bar.value = boss_health
	

func set_default_process_modes() -> void:
	set_boss_process_modes(false)
	set_library_song_process_modes(false)
	

func set_boss_process_modes(toggle: bool = false) -> void:
	var process_mode: ProcessMode
	if toggle:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
	intro_sequence.process_mode = process_mode
	intro_sequence_transition.process_mode = process_mode
	player_character.process_mode = process_mode
	boss.process_mode = process_mode
	electric_beam.process_mode = process_mode
	into_stage.process_mode = Node.PROCESS_MODE_DISABLED
	vignette.process_mode = process_mode

		
func set_library_song_process_modes(toggle: bool = false) -> void:
	var process_mode: ProcessMode
	if toggle:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
	lib_visuals.process_mode = process_mode
	video_layer_1.process_mode = process_mode
	video_layer_2.process_mode = Node.PROCESS_MODE_DISABLED
	video_layer_3.process_mode = Node.PROCESS_MODE_DISABLED
	video_layer_4.process_mode = Node.PROCESS_MODE_DISABLED
	video_layer_5.process_mode = Node.PROCESS_MODE_DISABLED
	confetti.process_mode = Node.PROCESS_MODE_DISABLED
	star_celebration.process_mode = Node.PROCESS_MODE_DISABLED
	combo_feedback_animation.process_mode = Node.PROCESS_MODE_DISABLED
	

func _ready() -> void:
	golden_notes_collected = 0
	if player_model.begins_with("boy_meta") or player_model.begins_with("girl_meta"):
		player_character.position.x += 22
	player_character.sprite_frames = load("res://scene_resources/animation_" + player_model + ".tres")
	boss.sprite_frames = load("res://scene_resources/animation_" + boss_model + ".tres")
	player_portrait.texture = load("res://art/18_dec/Avatars/Player/" + player_model + ".png")
	boss_portrait.texture = load("res://art/18_dec/Avatars/Boss/" + boss_model + ".png")
	boss_label.text = boss_name
	player_name_label.text = player_name
	show_debug()
	set_default_visibility()
	set_default_process_modes()
	if game_mode == "boss":
		set_boss_visibility(true)
		set_boss_process_modes(true)
		player_character.play("idle")

	elif game_mode == "library":
		set_library_song_process_modes(true)
		set_library_song_visibility(true)
		print("setting library visibility")
		
	losing = false
	winning = false
	var path: String = song_path
	music_player.stream = load(song_path)
	music_player_slow.stream = load(slow_song_path)
	set_player_health()
	set_boss_health()
	initialize_part(ui_type)
	setup_score_manager()
	#setup_combo()
	#set_star_bar_values()
	if ui_type == "treble":
		right_hand_part.position.y += 60
		blue_line.find_child("SingleLine").visible = true
		blue_line.find_child("MultiLine").visible = false
	else:
		blue_line.find_child("SingleLine").visible = false
		blue_line.find_child("MultiLine").visible = true
	level.position = Vector2(0,0)
	reset_health_bars()
	detector_position_x = notes_detector.position.x
	if game_mode == "boss":
		boss.play("idle")
		if not cheat_skip_middle_c:
			continue_note_popup.visible = true
		if Game.game_state == "Intro" and not cheat_skip_intro and not last_game_lost:
			intro_sequence.process_mode = Node.PROCESS_MODE_INHERIT
			#intro_sequence.play("intro")
			intro_sequence.play()
			#audio.stream = audio_clips.fight_starts
			#audio.play()
			#await intro_sequence.animation_finished
			await intro_sequence.finished
			intro_sequence_transition.visible = true
			intro_sequence_transition.play()
			await intro_sequence_transition.animation_finished
			intro_sequence.visible = false
			intro_sequence_transition.visible = false
			intro_sequence.process_mode = Node.PROCESS_MODE_DISABLED
			intro_sequence_transition.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			intro_sequence.visible = false
			intro_sequence.process_mode = Node.PROCESS_MODE_DISABLED
		if not cheat_skip_middle_c:
			await notes_detector.continue_note_played
			continue_note_popup.visible = false
	elif game_mode == "library":
		#if not tutorial_closed:
		combo_tutorial_popup.visible = true
		combo_tutorial_popup.find_child("ContinueButton").visible = false
		var combo_tutorial_progress: PopupProgressBar = combo_tutorial_popup.find_child("ButtonProgress")
		combo_tutorial_progress.start_closing_timer(5)
		await combo_tutorial_progress.timer.timeout
		combo_tutorial_popup.find_child("ContinueButton").visible = true
		await combo_tutorial_popup.find_child("ContinueButton").button_up
	music_player.play()
	pause_button.visible = true
	restart_button.visible = true
	game_state = "Playing"
	
	set_star_bar_values()
	
	#score_manager.combo_full_hits = roundi(score_manager.total_notes_in_level / 10)
	#score_manager.perfect_score = score_manager.perfect_score_in_level()
	#score_manager.three_stars_score = score_manager.three_stars_score_in_level()
	#star3_threshold_score = score_manager.three_stars_score / score_manager.perfect_score * star3_threshold_modifier
	#print("star 3 threshold is: " + str(star3_threshold_score))
	#set_star_bar_values()



func setup_score_manager() -> void:
	score_manager.total_net_notes_in_level = notes_container.notes_in_level
	score_manager.total_notes_in_level = notes_container.notes_value_in_level

func setup_combo() -> void:
	combo_feedback_animation.visible = false
	update_combo_meter()

func initialize_part(hand_parts: String = ui_type) -> void:
	if hand_parts.to_lower() == "bass" or hand_parts.to_lower() == "both":
		note_play_position_x = notes_detector.position.x
		starting_position = ending_point.position
		notes_container.construct_level(hand_parts, parser.get_melody_array_by_file(right_melody_path),
										parser.get_melody_array_by_file(left_melody_path), on_display_duration)
	elif hand_parts.to_lower() == "treble":
		bottom_staff.visible = false
		note_play_position_x = notes_detector.position.x
		starting_position = ending_point.position
		notes_container.construct_level(hand_parts, parser.get_melody_array_by_file(right_melody_path),[], on_display_duration)

func health_bars_progress(delta: float, rate: float = 1) -> void:
	player_health_progress += delta * rate
	player_health_progress = clamp(player_health_progress,0,1)
	player_health_bar.value = lerp(player_previous_health,player_new_health,player_health_progress)
	player_health_bar_long.value = lerp(player_previous_health,player_new_health,player_health_progress)
	boss_health_progress += delta * rate
	boss_health_progress = clamp(boss_health_progress,0,1)
	boss_health_bar.value = lerp(boss_previous_health,boss_new_health,boss_health_progress)
	
	player_panel.find_child("HealthValue").text = str(player_health_bar.value)
	boss_panel.find_child("HealthValue").text = str(boss_health_bar.value)

	

func enter_win_ui() -> void:
	var new_position: Vector2 = Vector2(player_character.global_position.x,player_character.global_position.y - 300)
	#player_character.find_child("Expander").move(new_position, 0.35)
	win_buttons.visible = true

func enter_lose_ui() -> void:
	var new_position: Vector2 = Vector2(boss.global_position.x,boss.global_position.y - 300)
	#player_character.find_child("Expander").move(new_position, 0.35)
	win_buttons.visible = true

func bob_head() -> void:
	var character_head_mover: Expander = character.find_child("CharacterHead").find_child("Expander")
	if character_head_mover.finished_reverse_moving:
		var character_head_target_position: Vector2 = character.find_child("CharacterHead").global_position + Vector2(-6,4)
		character_head_mover.move(character_head_target_position,0.04,true,true)

func beat_effects() -> void:
	#bob_head()
	#play_crowd_animations()
	if fading_music:
		beats_before_ending_music_counter += 1
	single_glow.find_child("Expander").expand(1.1,0.3,true,2)
	multi_glow.find_child("Expander").expand(1.1,0.3,true,2)
	#if game_mode == "library":
		#lib_visuals.find_child("LeftSpeaker").find_child("Grill").find_child("Expander").expand(1.1,0.3,true)
		#lib_visuals.find_child("RightSpeaker").find_child("Grill").find_child("Expander").expand(1.1,0.3,true)

#func play_crowd_animations() -> void:
	#for person: AnimatedSprite2D in crowd_people:
		#person.play()	

func update_score_visual(delta: float) -> void:
	if current_score_visual_time < score_visual_time:
		current_score_visual_time += delta * 0.7
		score_meter.self_modulate = lerp(Color.WHITE,score_success_color, clamp(current_score_visual_time/score_visual_time,0,1))
	else:
		current_score_visual_time += delta * 2
		score_meter.self_modulate = lerp(score_success_color,Color.WHITE, clamp((current_score_visual_time-score_visual_time)/score_visual_time,0,1))

func fade_boss_music() -> void:
	if beats_before_ending_music_counter >= beats_before_ending_music:
		if not music_ending_player.playing and not played_ending_music:
			music_ending_player.play()
			played_ending_music = true
		music_player.volume_db = clamp(music_player.volume_db - music_fade_out_amount,-80,0)
		#music_ending_player.volume_db = 0
		var new_volume: float = clamp(music_ending_player.volume_db + music_fade_in_amount,-80,0)
		music_ending_player.volume_db = new_volume
		music_fade_in_amount *= 0.9
		music_fade_out_amount *= 1.1

func _process(delta: float) -> void:
	if construction_complete and not losing and not winning and music_player.playing and grace_period_finished:
		vulnerable = true
	#update_score_visual(delta)
	update_golden_meter(delta)
	update_debug()
	health_bars_progress(delta, health_rate)
	if fade_right_hand_part: # I'm really not sure why it can't call the fader child, so this is manual.
		right_hand_part.modulate.a -= 0.01
	if game_mode == "boss" and fading_music and music_ending_player.stream:
		fade_boss_music()
	if game_mode == "library" and not sp_mode:
		update_ingame_stars()
		update_score_meter()
	if not boss.is_playing() and not losing and not winning and game_mode == "boss":
		if boss_health > boss_health_bar.max_value / 2:
			boss.play("idle")
		else:
			boss.play("damaged_idle")
	
	if not player_character.is_playing() and not winning and not losing and game_mode == "boss":
		player_character.play("idle")
		#player_bot.play("fly")
	time_elapsed += delta
	if time_elapsed > vul_time:
		grace_period_finished = true
		
	var stream: AudioStream = music_player.stream
	var song_length: float = stream.get_length()
	
	level_length_in_bar = notes_container.level_length_in_bars
	song_length = (60.0 / tempo) * 4.0 * level_length_in_bar
	
	var normalized_song_position: float = music_player.get_playback_position() / song_length
	if slow_down:
		song_length = (60.0 / (tempo * slow_down_percentage)) * 4.0 * level_length_in_bar
		normalized_song_position = music_player_slow.get_playback_position() / song_length
	var starting_position_x: float = notes_container.get_size() -abs(note_play_position_x)
	ending_point.position.x = lerp(starting_position_x,note_play_position_x,normalized_song_position)
	if ending_point.position.x <= note_play_position_x:
		print("finished level")
		if not winning and not losing:
			win()
		else:
			print("boss is dying, no lose for you")
	if just_started:
		notes_detector.clear_notes()
		bottom_notes_detector.clear_notes()
		just_started = false


func update_score_meter() -> void:
	score_meter.text = str(score_manager.game_score)

func update_combo_meter() -> void:
	var target_frame: int = int(90 * score_manager.combo_progress())
	animate_combo_frame(combo_animation, target_frame, 0.1)
	
	if score_manager.combo_mode_changed and not sp_mode:
		var animation_name: String = "combo_" + str(score_manager.combo_multiplier())
		
		match score_manager.combo_mode:
			ScoreManager.ComboMode.X1:
				top_upper_glow.stop()
				top_upper_glow.visible = false
				top_upper_glow.modulate = Color.WHITE
			ScoreManager.ComboMode.X2:
				top_upper_glow.play("Level4")
				top_upper_glow.visible = true
				top_upper_glow.modulate = level2_color
				play_combo_feedback_animation("combo_2")
			ScoreManager.ComboMode.X3:
				top_upper_glow.play("Level4")
				top_upper_glow.visible = true
				top_upper_glow.modulate = level3_color
				play_combo_feedback_animation("combo_3")
			ScoreManager.ComboMode.X4:
				top_upper_glow.play("Level4")
				top_upper_glow.visible = true
				top_upper_glow.modulate = level4_color
				play_combo_feedback_animation("combo_4")
		
		if ui_type =="treble":
			match score_manager.combo_mode:
				ScoreManager.ComboMode.X1:
					top_bottom_glow.stop()
					top_bottom_glow.visible = false
					top_bottom_glow.modulate = Color.WHITE
				ScoreManager.ComboMode.X2:
					top_bottom_glow.play("Level4")
					top_bottom_glow.visible = true
					top_bottom_glow.modulate = level2_color
				ScoreManager.ComboMode.X3:
					top_bottom_glow.play("Level4")
					top_bottom_glow.visible = true
					top_bottom_glow.modulate = level3_color
				ScoreManager.ComboMode.X4:
					top_bottom_glow.play("Level4")
					top_bottom_glow.visible = true
					top_bottom_glow.modulate = level4_color
		else:
			match score_manager.combo_mode:
				ScoreManager.ComboMode.X1:
					bottom_bottom_glow.stop()
					bottom_bottom_glow.visible = false
					bottom_upper_glow.stop()
					bottom_upper_glow.visible = false
					bottom_bottom_glow.modulate = Color.WHITE
					bottom_upper_glow.modulate = Color.WHITE
				ScoreManager.ComboMode.X2:
					bottom_bottom_glow.play("Level4")
					bottom_bottom_glow.visible = true
					#bottom_upper_glow.play("Level2")
					#bottom_upper_glow.visible = true
					bottom_bottom_glow.modulate = level2_color
					#bottom_upper_glow.modulate = level2_color
				ScoreManager.ComboMode.X3:
					bottom_bottom_glow.play("Level4")
					bottom_bottom_glow.visible = true
					#bottom_upper_glow.play("Level3")
					#bottom_upper_glow.visible = true
					bottom_bottom_glow.modulate = level3_color
					#bottom_upper_glow.modulate = level3_color
				ScoreManager.ComboMode.X4:
					bottom_bottom_glow.play("Level4")
					bottom_bottom_glow.visible = true
					#bottom_upper_glow.play("Level4")
					#bottom_upper_glow.visible = true
					bottom_bottom_glow.modulate = level4_color
					#bottom_upper_glow.modulate = level4_color
		
		if score_manager.combo_mode != ScoreManager.ComboMode.X1:
			play_combo_audio("res://audio/combo_advanced.ogg")
			combo_meter.find_child("ComboFire").play()
		else:
			play_combo_audio("res://audio/combo_lost.ogg")
		combo_meter.find_child("Expander").expand(1.25, 0.25, true)

# Helper function to animate the combo_animation frame progressively
func animate_combo_frame(animation: AnimatedSprite2D, target_frame: int, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(animation, "frame", target_frame, duration)
	
	# Wait for the tween to finish
	await tween.finished
	
	# Perform the update after the tween animation ends
	animation.animation = "combo_bar_" + str(score_manager.combo_multiplier())
	animation.frame = int(90 * score_manager.combo_progress())

# Helper function to play the combo feedback animation
func play_combo_feedback_animation(animation_name: String) -> void:
	combo_meter.find_child("ComboFire").play()
	combo_feedback_animation.visible = true
	combo_feedback_animation.play(animation_name)
	await combo_feedback_animation.animation_finished
	combo_feedback_animation.visible = false

# Helper function to play combo audio
func play_combo_audio(audio_path: String) -> void:
	combo_audio_player.stream = load(audio_path)
	combo_audio_player.play()


func _on_music_player_finished() -> void:
	print("finished!")
	if not winning and not losing and game_mode == "boss":
		win()

func fade_elements() -> void:
	pause_button.disabled = true
	restart_button.disabled = true
	pause_button.visible = false
	restart_button.visible = false
	#right_hand_part.find_child("Fader").fade_out()
	fade_right_hand_part = true
	detector_visual.find_child("Fader").fade_out()
	player_panel.find_child("Fader").fade_out()
	boss_panel.find_child("Fader").fade_out()
	player_health_bar.find_child("Fader").fade_out()
	player_health_bar_long.find_child("Fader").fade_out()
	player_health_bar_fake.find_child("Fader").fade_out()
	boss_health_bar.find_child("Fader").fade_out()
	
func lose() -> void:
	losing = true
	vulnerable = false
	#boss.stop()
	fade_elements()
	var timer: Timer = new_timer(1.2)
	timer.start()
	player_character.visible = false
	player_bot.visible = false
	await timer.timeout
	boss_win_animation()
	music_player_slow.stop()
	play_music_clip(audio_clips.player_loses)
	await boss.animation_finished
	timer.wait_time = 0.5
	timer.start()
	await timer.timeout
	game_state = "Lose"
	last_game_lost = true
	enter_lose_ui()

# Adjust this for the delay between each star animation
const ANIMATION_DELAY = 0.4
const FADE_DURATION = 0.2

func animate_xp(start_value: int, end_value: int, duration: float) -> void:
	xp_label.visible = true
	xp_label.text = "Score: "
	
	# Create a Tween node dynamically
	var tween: Tween = create_tween()
	# Interpolate the XP value over the specified duration
	tween.tween_property(self, "current_xp", end_value, duration)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	# Connect the tween's completion signal to a function
	tween.finished.connect(Callable(self, "_on_tween_completed"))
	# Start the tween
	tween.play()

func _on_tween_completed(tween: Tween) -> void:
	# Ensure the label displays the final XP value
	xp_label.text = "Score: " + str(target_xp)
	# Play the completion sound
	xp_audio_player.play()
	# Remove the tween node after completion
	tween.queue_free()

# Property to update the label text during the tween
var current_xp: int = 0:
	set(value):
		current_xp = value
		xp_label.text = "Score: " + str(value)
		
func show_stars() -> void:
	if game_mode == "library":
		stars.visible = true
		xp.visible = true
	else:
		stars.visible = false
		xp.visible = false
		return
		
	stars.find_child("Fader").fade_in()
	
	# Ensure stars are set to the first frame initially
	star1.frame = 0
	star2.frame = 0
	star3.frame = 0
	
	var stars_to_animate: int = int(score_manager.stars)
	animate_xp(0, score_manager.game_score, FADE_DURATION + ANIMATION_DELAY * stars_to_animate)
	animate_stars(stars_to_animate)

func display_performance_message(sp_screen: bool = sp_mode) -> void:
	win_text.visible = false
	var stars: int = int(score_manager.stars)
	var message: String = ""
	if not sp_mode:
		match stars:
			0:
				message = "ניסיון יפה!"
			1:
				message = "הופעה טובה!"
			2:
				message = "הופעה נהדרת!"
			3:
				message = "ביצוע מדהים!"
			_:
				message = ""
	else:
		message = "סיימת את השיר!"
		win_text.text = message
		win_text.pivot_offset.x = win_text.size.x / 2
		win_text.pivot_offset.y = win_text.size.y / 2
		win_text.scale *= 0.5

	# Display the message (for example, in a Label node)
	win_text.text = message
	win_text.visible = true

func animate_stars(stars_count: int) -> void:
	star1.visible = true
	star1.modulate.a = 0.4
	star2.visible = true
	star2.modulate.a = 0.4
	star3.visible = true
	star3.modulate.a = 0.4
	
	# Animate each star gradually
	if stars_count >= 1:
		var tween: Tween = create_tween()
		tween.tween_property(star1, "modulate:a", 1, FADE_DURATION)
		star1.play("activate_star")  # Start first star animation
		await get_tree().create_timer(ANIMATION_DELAY).timeout
		stars_audio_player.stream = preload("res://audio/star1.mp3")
		stars_audio_player.play()

	if stars_count >= 2:
		var tween: Tween = create_tween()
		tween.tween_property(star2, "modulate:a", 1, FADE_DURATION)
		star2.play("activate_star")  # Start second star animation
		await get_tree().create_timer(ANIMATION_DELAY).timeout
		stars_audio_player.stream = preload("res://audio/star2.mp3")
		stars_audio_player.play()

	if stars_count == 3:
		var tween: Tween = create_tween()
		tween.tween_property(star3, "modulate:a", 1, FADE_DURATION)
		star3.play("activate_star")  # Start third star animation
		await get_tree().create_timer(ANIMATION_DELAY).timeout  # Wait for the last animation to finish
		stars_audio_player.stream = preload("res://audio/star3.mp3")
		stars_audio_player.play()
		
	fade_out_non_animated_stars(stars_count)

func fade_out_non_animated_stars(stars_count: int) -> void:
	var tween: Tween = create_tween()

	if stars_count < 1:
		tween.tween_property(star1, "modulate:a", 0.1, FADE_DURATION)
	if stars_count < 2:
		tween.tween_property(star2, "modulate:a", 0.1, FADE_DURATION)
	if stars_count < 3:
		tween.tween_property(star3, "modulate:a", 0.1, FADE_DURATION)

func win() -> void:
	if not sp_mode and game_mode == "library":
		show_library_song_end_screen()
		return
	
	winning = true
	fading_music = true
	vulnerable = false
	fade_elements()
	var timer: Timer = new_timer(1)
	timer.start()
	await timer.timeout
	
	if game_mode == "boss":
		boss.stop()
		boss.play("death")
		music_ending_player.stream = load(Game.ending_music_path)
		audio_play_from_source(boss, audio_clips.boss_death)
		await boss.animation_finished
		boss.visible = false
		if music_ending_player.stream and music_ending_player.playing:
			await music_ending_player.finished
	music_player_slow.stop()
	if game_mode == "library":
		play_music_clip(audio_clips.song_end_music)
	else:	
		fading_music = false
		music_ending_player.stop()
		music_player.volume_db = 0
		play_music_clip(audio_clips.player_wins)
	into_stage.process_mode = Node.PROCESS_MODE_INHERIT
	into_stage.visible = true
	into_stage.play()
	win_text.visible = true
	win_text.find_child("Fader").fade_in()
	
	if game_mode == "boss":
		win_text.text = "ניצחון!"
		player_win_animation()
		await player_character.animation_finished
	else: 
		display_performance_message(true)
	show_stars()
	timer.wait_time = 0.5
	timer.start()
	await timer.timeout
	game_state = "Win"
	last_game_lost = false
	enter_win_ui()
	JourneyManager.mark_current_level_as_complete()

func new_timer(wait_time: float = 2.0) -> Timer:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait_time
	return timer

#func _on_hit_zone_body_entered(note: Note) -> void:
	#if note.state == "Active":
		#get_hit()
	#else:
		#print("not active, not interesting")

func hide_tutorial() -> void:
	tutorial.visible = false


func show_tutorial(for_type: String = "player_portrait") -> void:
	tutorial.visible = true
	popup_progress_bar.start_closing_timer(5)
	tutorial.find_child("Heart").visible = false
	tutorial.find_child("Slowdown").visible = false
	tutorial.find_child("Bomb").visible = false
	match for_type:
		"player_portrait":
			tutorial_text.text = "אספת לב!"
			tutorial.find_child("Heart").visible = true
		"slowdown":
			tutorial_text.text = "אספת האטת זמן!"
			tutorial.find_child("Slowdown").visible = true
			
		"bomb":
			tutorial_text.text = "פגעת בפצצה!
זהירות, זה מוריד לך חיים!"
			tutorial.find_child("Bomb").visible = true
			
		_:
			tutorial_text.text = "ERROR TYPE NOT FOUND"

func activate_effect(effect: String = "slowdown", details: Dictionary = {}) -> void:
	match effect:
		"slowdown":
			var is_timed: bool = not details.has("action") or not details["action"] == "start"
			if not slowdown_collected:
				slowdown_collected = true
				#show_tutorial(effect)
				#pause(true)
				#await game_resumed
				level_slow_down(is_timed)
			else:
				level_slow_down(is_timed)
		"bomb":
			if not bomb_collected:
				bomb_collected = true
				#show_tutorial(effect)
				#pause(true)
				#await game_resumed
				get_hit()
			else:
				get_hit()
		"heart":
			if not health_collected:
				health_collected = true
				#show_tutorial(effect)
				#pause(true)
				#await game_resumed
				heal(3)
			else:
				heal(3)
		"golden_note":
			golden_notes_collected += 1
			if game_mode == "boss":
				hit_boss(-5)
			else:
				score_manager.add_note_score(golden_note_value, true)
			score_manager.total_hits += 1
			score_manager.total_passed_notes += 1
			#audio.stream = audio_clips.golden_note
			#audio.play()
		_:
			print("no specific effect")
			
	
func deactivate_effect(effect: String = "slowdown") -> void:
	match effect:
		"slowdown":
			if slowdown_collected:
				level_accelerate()

func heal(amount: int = 1) -> void:
	amount = amount + heart_healing_bonus
	update_player_health(amount)
	audio.stream = audio_clips.heart
	audio.play()
	player_health_bar.find_child("Flash").flash(Color.LIGHT_SEA_GREEN, 0.25)
	player_health_bar.find_child("Expander").expand(1.10, 0.25, true)
	player_health_bar_long.find_child("Flash").flash(Color.LIGHT_SEA_GREEN, 0.25)
	player_health_bar_long.find_child("Expander").expand(1.10, 0.25, true)
	player_health_bar_fake.find_child("Flash").flash(Color.LIGHT_SEA_GREEN, 0.25)
	player_health_bar_fake.find_child("Expander").expand(1.10, 0.25, true)
	player_portrait.find_child("Expander").expand(1.10, 0.25, true)

func hit_boss(damage: float = -1) -> void:
	if not winning and not losing and game_mode == "boss":
		handle_note_effects()
		handle_visual_effects()
		play_boss_audio()
		handle_player_attack_animation()
		damage = damage * character_attack_modifier
		handle_boss_hit(damage)
		check_boss_health()



func handle_note_effects() -> void:
	if ui_type == "treble":
		blue_line.find_child("SingleLine").find_child("LineZapSingle").play("line_zap")
		top_staff_power.find_child("Fader").fade_in_and_out(0.07,0.04)
		top_staff_power_lower.find_child("Fader").fade_in_and_out(0.07,0.04)
		#right_hand_part.find_child("UpperStaff").find_child("ElectricBolt2").play()
	else:
		blue_line.find_child("MultiLine").find_child("LineZapMulti").play("line_zap")
		top_staff_power.find_child("Fader").fade_in_and_out(0.07,0.04)
		bottom_staff_power.find_child("Fader").fade_in_and_out(0.07,0.04)
		#right_hand_part.find_child("BottomStaff").find_child("ElectricBolt").play()
	#right_hand_part.find_child("UpperStaff").find_child("ElectricBolt").play()

func handle_visual_effects() -> void:
	boss.find_child("Flash").flash(Color.RED)
	boss_health_bar.find_child("Flash").flash(Color.RED)
	boss_health_bar.find_child("Expander").expand(1.20, 0.15, true)
	boss_portrait.find_child("Flash").flash(Color.RED)
	boss_portrait.find_child("Expander").expand(1.20, 0.15, true)


func play_boss_audio() -> void:
	audio_play_from_source(electric_beam, audio_clips.electric_attack, -10.5)
	audio_play_from_source(boss, audio_clips.boss_hit, -10.5)


func handle_player_attack_animation() -> void:
	player_character.stop()
	player_bot.stop()
	player_character.play("attack")
	player_bot.play("attack")


func handle_boss_hit(damage: float) -> void:
	update_boss_health(damage)
	boss.stop()
	var strong_string: String
	if strong_attacks:
		strong_string = "_strong"
	else:
		strong_string = ""
	if boss_health < boss_health_bar.max_value / 2 or boss_health <= 1:
		boss.play("damaged_get_hit" + strong_string)
	else:
		boss.play("get_hit" + strong_string)


func check_boss_health() -> void:
	if boss_health <= 0:
		win()

func golden_note_missed() -> void:
	score_manager.miss_golden_note()

func audio_play_from_source(source: Node, audio_clip: AudioStream, volume: float = 1.0) -> void:
	source.find_child("Audio").stream = audio_clip
	source.find_child("Audio").volume_db = volume
	source.find_child("Audio").play()

func update_player_health(health_change: float = -1) -> void:
	player_health_progress = 0
	player_previous_health = player_health
	player_health += health_change
	player_health = clamp(player_health, 0, player_health_bar.max_value)
	player_new_health = player_health
	if player_health <= player_health_bar.max_value / 6 or player_health <= 1:
		player_health_bar.tint_progress = Color.RED
		player_health_bar_long.tint_progress = Color.RED
	else:
		player_health_bar.tint_progress = original_health_color
		player_health_bar_long.tint_progress = original_health_color

func boss_visual_damage() -> void:
	if boss_health <= boss_health_bar.max_value / 6 or boss_health <= 1:
		boss_health_bar.tint_progress = Color.RED
	
func update_boss_health(health_change: float = -1) -> void:
	boss_health_progress = 0
	boss_previous_health = boss_health
	boss_health += health_change
	boss_new_health = boss_health
	boss_visual_damage()
	

func get_hit(damage: float = -1.0) -> void:
	if game_mode == "boss":
		if vulnerable and not winning and not losing:
			got_hit_atleast_once = true
			#player_character.find_child("Flash").flash(Color.RED)
			player_character.play("get_hit")
			player_character.find_child("Flash").flash(Color.RED)
			player_bot.play("get_hit")
			player_bot.find_child("Flash").flash(Color.RED)
			audio_play_from_source(player_character, audio_clips.player_hit,-8)
			damage = damage / character_health_modifier
			update_player_health(damage)
			#player_health_bar.value = player_health
			player_health_bar.find_child("Flash").flash(Color.RED)
			player_health_bar.find_child("Expander").expand(1.20, 0.15, true)
			player_health_bar_long.find_child("Flash").flash(Color.RED)
			player_health_bar_long.find_child("Expander").expand(1.20, 0.15, true)
			player_health_bar_fake.find_child("Flash").flash(Color.RED)
			player_health_bar_fake.find_child("Expander").expand(1.20, 0.15, true)
			player_portrait.find_child("Flash").flash(Color.RED)
			player_portrait.find_child("Expander").expand(1.20, 0.15, true)
			
			if player_health <= 0 and not winning and not losing:
				lose()

func reset_health_bars() -> void:
	#if not bigger_health:
		#player_health_bar.max_value = player_health * 1.2
	#else:
		#player_health_bar.max_value = player_health
	player_health_bar.max_value = player_health
	player_health_bar.value = player_health
	player_health_bar_long.max_value = player_health
	player_health_bar_long.value = player_health
	player_new_health = player_health
	player_previous_health = player_health
	boss_health_bar.max_value = boss_health
	boss_health_bar.value = boss_health
	boss_new_health = boss_health
	boss_previous_health = boss_health

func restart_level(wait: bool = false, type: String = "normal") -> void:
	Game.repeat_requested = true
	music_player.stream_paused = true
	if wait:
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.start(0.8)
		await timer.timeout
	get_tree().paused = false
	#get_tree().reload_current_level()
	var game: Game = NodeHelper.move_to_scene(self, "res://scenes/game.tscn")
	game.model = model
	

func _on_boss_hit_zone_body_entered(note: Note) -> void:
	if note.state.to_lower() != "rest" and not winning and not losing:
		if not boss.animation == "get_hit" and not boss.animation == "damaged_get_hit":
			if boss_health > boss_health_bar.max_value / 2:
				boss.play("attack")
			else:
				boss.play("damaged_attack")


func _on_pause_button_up() -> void:
	pause(true)


func _on_restart_button_up() -> void:
	restart_level(false,current_difficulty)

func boss_win_animation() -> void:
	boss.find_child("Expander").expand(1.25, 0.5)
	boss.find_child("Expander").move(Vector2(0,0), 0.5)
	boss.stop()
	boss.play("win")
	into_stage.process_mode = Node.PROCESS_MODE_INHERIT
	into_stage.flip_h = true
	into_stage.visible = true
	into_stage.play()
	lose_text.visible = true
	lose_text.find_child("Fader").fade_in()

func player_win_animation() -> void:
	player_character.find_child("Expander").expand(1.5, 0.25)
	player_character.find_child("Expander").move(Vector2(0,0), 0.25)
	player_character.stop()
	player_character.play("win")
	

func start_score_visual() -> void:
	score_meter.find_child("Expander").expand(1.35,0.25,true)
	golden_meter.find_child("Expander").expand(1.35, 0.25, true)
	
	current_score_visual_time = 0

func _on_resume_button_up() -> void:
	tutorial.visible = false
	popup_progress_bar.timer.stop()
	pause()


func _on_win_change_level_button_up() -> void:
	if game_mode == "boss":
		get_tree().paused = false
		if last_menu == "boss_library":
			NodeHelper.move_to_scene(self, "res://scenes/boss_screen.tscn")
		else:
			NodeHelper.move_to_scene(self, "res://scenes/journey_screen.tscn")
	else:
		NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")

func _on_win_restart_button_up(show_easy: bool = false) -> void:
	Game.repeat_requested = true
	if game_mode == "boss":
		if last_menu == "boss_library":
			restart_level()
		else:
			NodeHelper.move_to_scene(self, "res://scenes/characters_screen.tscn")
		
		#if has_easy_difficulty:
			#show_easy = true
		#darken.visible = true
		#if show_easy:
			#easy_button.visible = true
		#else:
			#easy_button.visible = false
		#difficulty.visible = true
	else:
		#get_tree().paused = false
		#get_tree().reload_current_level()
		#restart_level()
		NodeHelper.move_to_scene(self, "res://scenes/song_difficulty_screen.tscn", Callable(self, "on_song_difficulty_screen_created"))

func on_song_difficulty_screen_created(song_difficulty_screen: SongDifficultyScreen) -> void:
	song_difficulty_screen.model = model


func on_boss_difficulty_screen_created(boss_difficulty_screen: BossDifficultyScreen) -> void:
	boss_difficulty_screen.model = model


func _on_win_continue_button_up() -> void:
	if game_mode == "boss":
		if last_menu == "boss_library":
			NodeHelper.move_to_scene(self, "res://scenes/boss_screen.tscn")
		else:
			NodeHelper.move_to_scene(self, "res://scenes/journey_screen.tscn")
	else:
		NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")


func play_music_clip(audioclip: AudioStream = audio_clips.player_wins) -> void:
	music_player.stream = audioclip
	music_player.play()


func _on_popup_timer_timeout() -> void:
	tutorial.visible = false
	pause()


func _on_return_button_up() -> void:
	Game.game_state = "Winning"
	pause()
	if game_mode == "boss":
		if last_menu == "boss_library":
			NodeHelper.move_to_scene(self, "res://scenes/boss_screen.tscn")
		else:
			NodeHelper.move_to_scene(self, "res://scenes/journey_screen.tscn")
	else:
		NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")

func get_lose_state() -> bool:
	return losing

func _on_easy_button_button_up() -> void:
	restart_level(false, "easy")

func _on_normal_button_button_up() -> void:
	restart_level(false, "normal")


func _on_hard_button_button_up() -> void:
	restart_level(false, "hard")

func miss_note() -> void:
	missed_notes += 1
	if game_mode == "boss":
		get_hit()

func show_debug(toggle: bool = debug) -> void:
	debug_window.visible = toggle
	debug_missed_notes.visible = toggle
	debug_notes_in_level.visible = toggle
	debug_gamified_score.visible = false
	debug_overall_score.visible = toggle
	#debug_vulnerable.visible = toggle
	debug_perfect_score.visible = toggle
	debug_difficulty.visible = toggle
	
	player_panel.find_child("HealthValue").visible = toggle
	boss_panel.find_child("HealthValue").visible = toggle
	

func update_debug() -> void:
	debug_difficulty.text = current_difficulty
	debug_missed_notes.text = "missed notes: " + str(missed_notes)
	debug_notes_in_level.text = "notes in level: " + str(notes_container.notes_in_level)
	if score_based_stars:
		debug_overall_score.text = "game score: " + str(snapped(score_manager.gamified_overall_score,0.001)*100.0) + "%"
	else:
		debug_overall_score.text = "overall score: " + str(snapped(score_manager.overall_score,0.01)*100.0) + "%"
	debug_perfect_score.text = "perfect score: " + str(round(score_manager.perfect_score))
	debug_vulnerable.text = "vulnerable: " + str(vulnerable)

func _on_move_to_end_screen_button_pressed() -> void:
	win()

func show_library_song_end_screen() -> void:
	fade_elements()
	var timer: Timer = new_timer(1)
	timer.start()
	await timer.timeout
	score_manager.get_parent().remove_child(score_manager)
	var song_end_screen: Node2D = NodeHelper.move_to_scene(self, "res://scenes/song_end_screen.tscn", Callable(self, "on_song_end_screen_created"))
	song_end_screen.get_tree().get_root().add_child(score_manager)

func on_song_end_screen_created(song_end_screen: SongEndScreen) -> void:
	song_end_screen.score_manager = score_manager
	song_end_screen.model = model
	

func move_to_song_library() -> void:	
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")


func _on_animation_animation_finished() -> void:
	star_celebration.process_mode = Node.PROCESS_MODE_DISABLED


func _on_confetti_animation_finished() -> void:
	confetti.process_mode = Node.PROCESS_MODE_DISABLED


func _on_continue_button_button_up() -> void:
	combo_tutorial_popup.visible = false
	tutorial_closed = true
