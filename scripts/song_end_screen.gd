extends Node2D
class_name SongEndScreen

@onready var model: Dictionary
var total_stars: int
var total_hit_notes: int
var total_notes: int
var timing_score: float
var game_score: float

@onready var stars: Control = $UI/Stars
@onready var stars_animation: AnimatedSprite2D = $UI/Stars/StarsAnimation
@onready var confetti_animation: AnimatedSprite2D = $UI/ConfettiAnimation
@onready var stars_audio_player: AudioStreamPlayer = $UI/Stars/StarsAudioPlayer
@onready var xp_label: Label = $UI/XP/XPLabel
@onready var xp_audio_player: AudioStreamPlayer = $UI/XP/XPAudioPlayer
@onready var title: Label = $UI/Title
@onready var repeat_button: Button = $UI/Buttons/RepeatButton
@onready var continue_button: Button = $UI/Buttons/ContinueButton

# Adjust this for the delay between each star animation
const ANIMATION_DELAY = 0.4
const FADE_DURATION = 1

# Property to update the label text during the tween
var current_xp: int = 0:
	set(value):
		current_xp = value
		xp_label.text = str(value)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	animate_stars(total_stars)
	set_audio_stream_based_on_stars()
	set_buttons()
	display_performance_message()
	
		# Create a Timer
	var timer: Timer = Timer.new()
	timer.wait_time = 0.2 + 0.8 * total_stars / 3  # 1 second delay
	timer.one_shot = true  # Ensures the timer runs only once
	add_child(timer)  # Add the timer to the scene tree
	timer.start()  # Start the timer

	# Await the timer's timeout signal
	await timer.timeout
	change_background_color()
	if total_stars == 3:
		play_confetti_animation()
	animate_view($UI/Title)
	await get_tree().create_timer(0.2).timeout

	animate_xp(0, game_score, ANIMATION_DELAY * total_stars)
	animate_notes(total_hit_notes, total_notes)
	animate_timing(timing_score)

	animate_view($UI/Notes)
	animate_view($UI/Timing)
	animate_view($UI/YourScoreLabel)
	animate_view($UI/XP)
	
	await get_tree().create_timer(0.2).timeout
	animate_view($UI/Buttons)
	
	timer.queue_free()  # Clean up the timer
	
func set_buttons() -> void:
	if total_stars < 3:
		repeat_button.icon = load("res://art/RepeatButtonBold.png")
		continue_button.icon = load("res://art/ContinueButton.png")

func change_background_color() -> void:
	var tween: Tween = create_tween()
	 # Animate the color property of the ColorRect
	tween.tween_property(
		$UI/Background,  # The ColorRect node
		"color",  # The property to animate
		Color("#4f21b3"),  # Target color
		0.4  # Duration in seconds
	)
	tween.play()  # Start the tween


func animate_view(view: Node) -> void:
	var tween: Tween = create_tween()
	view.visible = true
	view.modulate.a = 0
	view.position.y -= 5
	# Animate the alpha (modulate.a)
	tween.tween_property(
		view,                     # The view to animate
		"modulate:a",             # Property to animate (alpha channel)
		1.0,                      # Duration in seconds
		0.3
	)
	
	# Animate the vertical position (rect_position.y)
	tween.tween_property(
		view,                     # The view to animate
		"position:y",        # Property to animate (Y position for Control nodes)
		view.position.y + 2,                       # Starting value (10px from bottom)
		0.1
	)
	
	# Start the tween
	tween.play()
	
func play_confetti_animation() -> void:
	confetti_animation.visible = true
	confetti_animation.play("end_screen_confetti")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func animate_notes(hit_notes: int, total_notes: int) -> void:
	var progress_bar: AnimatedSprite2D = $UI/Notes/NotesProgressBar
	var label: Label = $UI/Notes/NotesLabel
	
	label.text = "%d/%d Notes" % [hit_notes, total_notes]
	AnimationHelper.play_animation_sprite_until_frame(progress_bar, "progress_bar", float(hit_notes)/float(total_notes) * 36)
	
	
func animate_timing(timing_score: float) -> void:
	var progress_bar: AnimatedSprite2D = $UI/Timing/TimingProgressBar
	var label: Label = $UI/Timing/TimingLabel
	
	label.text = "%d%%" % int(timing_score * 100)
	AnimationHelper.play_animation_sprite_until_frame(progress_bar, "progress_bar", timing_score * 36)
	
func animate_xp(start_value: int, end_value: int, duration: float) -> void:
	xp_label.visible = true
	
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
	xp_label.text = str(Game.target_xp)
	# Play the completion sound
	xp_audio_player.play()
	# Remove the tween node after completion
	tween.queue_free()
		
func display_performance_message() -> void:
	var stars: int = int(total_stars)
	var message: String = ""
	match stars:
		0:
			message = "לא נורא, נסה שוב!"
		1:
			message = "ניסיון יפה!"
		2:
			message = "כל הכבוד!"
		3:
			message = "ביצוע מדהים!"
		_:
			message = ""

	# Display the message (for example, in a Label node)
	title.text = message

func animate_stars(stars_count: int) -> void:
	stars.visible = true
	stars.modulate.a = 0.4
	var tween: Tween = create_tween()
	tween.tween_property(stars, "modulate:a", 1, FADE_DURATION)
	var frame: int = {0: 0, 1: 13, 2: 21, 3: 30}.get(stars_count, -1)
	AnimationHelper.play_animation_sprite_until_frame(stars_animation, "stars_end_animation", frame)

func set_audio_stream_based_on_stars() -> void:
	stars_audio_player.stream = preload("res://audio/three_stars.wav")
	stars_audio_player.play()
	var audio_path: String
	match total_stars:
		1:
			audio_path = "res://audio/one_star.wav"
		2:
			audio_path = "res://audio/two_stars.wav"
		3:
			audio_path = "res://audio/three_stars.wav"
		_:
			audio_path = ""  # No audio for 0 or invalid values

	if audio_path != "":
		stars_audio_player.stream = load(audio_path)
		stars_audio_player.play()
	else:
		stars_audio_player.stream = null  # Clear the stream for no stars# Clear the audio stream

func _on_repeat_button_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/song_difficulty_screen.tscn", Callable(self, "on_song_difficulty_screen_created"))


func _on_continue_button_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")

func on_song_difficulty_screen_created(song_difficulty_screen: SongDifficultyScreen) -> void:
	song_difficulty_screen.model = model
