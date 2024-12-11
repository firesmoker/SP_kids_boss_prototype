extends Node2D
class_name SongEndScreen

@onready var model: Dictionary
@onready var score_manager: ScoreManager

@onready var video_background: VideoStreamPlayer = $UI/VideoBackground
@onready var stars: Control = $UI/Stars
@onready var stars_animation: AnimatedSprite2D = $UI/Stars/StarsAnimation
@onready var confetti_animation: AnimatedSprite2D = $UI/ConfettiAnimation
@onready var stars_audio_player: AudioStreamPlayer = $UI/Stars/StarsAudioPlayer
@onready var xp_container: Control = $UI/XP
@onready var xp_label_container: Label = $UI/YourScoreLabel
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
	animate_stars(score_manager.stars)
	set_audio_stream_based_on_stars()
	set_buttons()
	display_performance_message()
	
		# Create a Timer
	var timer: Timer = Timer.new()
	timer.wait_time = 0.2 + 0.8 * score_manager.stars / 3  # 1 second delay
	timer.one_shot = true  # Ensures the timer runs only once
	add_child(timer)  # Add the timer to the scene tree
	timer.start()  # Start the timer

	# Await the timer's timeout signal
	await timer.timeout
	change_background_color()
	if score_manager.stars == 3:
		play_confetti_animation()
	animate_view($UI/Title)
	await get_tree().create_timer(0.2).timeout

	update_xp(0, score_manager.game_score, ANIMATION_DELAY * score_manager.stars)
	animate_notes(score_manager.total_hits, score_manager.total_notes_in_level)
	animate_timing(score_manager.timing_score())

	animate_view($UI/Notes)
	animate_view($UI/Timing)
	animate_view($UI/YourScoreLabel)
	animate_view($UI/XP)
	
	await get_tree().create_timer(0.2).timeout
	animate_view($UI/Buttons)
	
	timer.queue_free()  # Clean up the timer
	
func set_buttons() -> void:
	if score_manager.stars < 3:
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
	
	tween = create_tween()
	video_background.modulate.a = 0
	# Animate the alpha (modulate.a)
	tween.tween_property(
		video_background,                     # The view to animate
		"modulate:a",             # Property to animate (alpha channel)
		1.0,                    
		0.4
	)
	video_background.play()
	
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
	
	label.text = "%d/%d" % [hit_notes, total_notes] + " תווים "
	AnimationHelper.play_animation_sprite_until_frame(progress_bar, "progress_bar", float(hit_notes)/float(total_notes) * 36)
	
	
func animate_timing(timing_score: float) -> void:
	var progress_bar: AnimatedSprite2D = $UI/Timing/TimingProgressBar
	var label: Label = $UI/Timing/TimingLabel
	
	label.text = "%d%%" % int(timing_score * 100) + " קצב "
	AnimationHelper.play_animation_sprite_until_frame(progress_bar, "progress_bar", timing_score * 36)
	
func update_xp(start_value: int, end_value: int, duration: float) -> void:
	xp_label.visible = true

	# Check if this is a new high score
	var is_new_high_score: bool = score_manager.update_best_score(Game.song_id, end_value)

	# Create a Tween node dynamically
	var tween: Tween = create_tween()
	tween.tween_property(self, "current_xp", end_value, duration)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	# Handle new high score animations
	if is_new_high_score:
		# Find the Expander node and trigger bounce animation
		var expander: Node = xp_container.find_child("Expander")
		if expander:
			expander.expand(1.5, 0.25, true)

		# Change the label text and colors for new high score
		xp_label_container.text = "שיא חדש!"  # New High Score in Hebrew
		xp_label_container.modulate = Color("#FFD44F")
		xp_label.modulate = Color("#200854")
		xp_container.modulate = Color("#FFD44F")

		# Add slide animation for the label text
		animate_label_slide(xp_label_container)

	tween.finished.connect(Callable(self, "_on_tween_completed"))
	tween.play()


func _on_tween_completed(tween: Tween) -> void:
	# Ensure the label displays the final XP value
	xp_label.text = str(Game.target_xp)
	# Play the completion sound
	xp_audio_player.play()
	# Remove the tween node after completion
	tween.queue_free()
		
func display_performance_message() -> void:
	var stars: int = int(score_manager.stars)
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
	stars_audio_player.stream = preload("res://audio/three_stars.ogg")
	stars_audio_player.play()
	var audio_path: String
	match score_manager.stars:
		1:
			audio_path = "res://audio/one_star.ogg"
		2:
			audio_path = "res://audio/two_stars.ogg"
		3:
			audio_path = "res://audio/three_stars.ogg"
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

func animate_label_slide(label: Label) -> void:
	var tween: Tween = create_tween()
	label.visible = true
	label.position.y -= 50  # Start position above the current position
	label.modulate.a = 0.0  # Start with transparency

	# Animate position and transparency
	tween.tween_property(label, "position:y", label.position.y + 50, 0.5)
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	tween.play()
