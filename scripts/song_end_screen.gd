extends Node2D
class_name SongEndScreen

@onready var stars: Control = $UI/Stars
@onready var stars_animation: AnimatedSprite2D = $UI/Stars/StarsAnimation
@onready var confetti_animation: AnimatedSprite2D = $UI/ConfettiAnimation
@onready var stars_audio_player: AudioStreamPlayer = $UI/Stars/StarsAudioPlayer
@onready var xp_label: Label = $UI/XP/XPLabel
@onready var xp_audio_player: AudioStreamPlayer = $UI/XP/XPAudioPlayer
@onready var win_text: Label = $UI/WinText
@onready var score_manager: ScoreManager = $ScoreManager

# Adjust this for the delay between each star animation
const ANIMATION_DELAY = 0.4
const FADE_DURATION = 0.2

# Property to update the label text during the tween
var current_xp: int = 0:
	set(value):
		current_xp = value
		xp_label.text = str(value)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_manager.stars = 3
	score_manager.game_score = 1000
	Game.target_xp = 2390
	var stars_to_animate: int = int(score_manager.stars)
	animate_xp(0, score_manager.game_score, FADE_DURATION + ANIMATION_DELAY * stars_to_animate)
	animate_stars(stars_to_animate)
	
	play_confetti_animation()
	

func play_confetti_animation() -> void:
	# Create a Timer
	var timer: Timer = Timer.new()
	timer.wait_time = 1.0  # 1 second delay
	timer.one_shot = true  # Ensures the timer runs only once
	add_child(timer)  # Add the timer to the scene tree
	timer.start()  # Start the timer

	# Await the timer's timeout signal
	await timer.timeout
	confetti_animation.visible = true
	confetti_animation.play("end_screen_confetti")
	timer.queue_free()  # Clean up the timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	var stars: int = int(score_manager.stars)
	var message: String = ""
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

	# Display the message (for example, in a Label node)
	win_text.text = message

func animate_stars(stars_count: int) -> void:
	stars.visible = true
	stars.modulate.a = 0.4
	var tween: Tween = create_tween()
	tween.tween_property(stars, "modulate:a", 1, FADE_DURATION)
	stars_animation.play("stars_end_animation")  # Start first star animation
	stars_audio_player.stream = preload("res://audio/three_stars.wav")
	stars_audio_player.play()
