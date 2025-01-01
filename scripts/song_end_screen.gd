extends Node2D
class_name SongEndScreen

@onready var model: Dictionary
@onready var score_manager: ScoreManager
@onready var golden_notes: Control = $UI/GoldenNotes

@onready var video_background: VideoStreamPlayer = $UI/VideoBackground
@onready var stars: Control = $UI/Stars
@onready var stars_animation: AnimatedSprite2D = $UI/Stars/StarsAnimation
@onready var confetti_animation: AnimatedSprite2D = $UI/ConfettiAnimation
@onready var stars_audio_player: AudioStreamPlayer = $UI/Stars/StarsAudioPlayer

@onready var xp_container: Control = $UI/XP
@onready var xp_background: TextureRect = $UI/XP/TextureRect
@onready var xp_label_title: Label = $UI/XP/YourScoreLabel
@onready var xp_label: Label = $UI/XP/XPLabel
@onready var xp_audio_player: AudioStreamPlayer = $UI/XP/XPAudioPlayer

@onready var combo_container: Control = $UI/Combo
@onready var combo_label: Label = $UI/Combo/ComboLabel
@onready var combo_animation: AnimatedSprite2D = $UI/Combo/ComboAnimation
@onready var combo_audio_player: AudioStreamPlayer = $UI/Combo/ComboAudioPlayer

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
	update_song_stars_results()
	animate_stars(score_manager.stars)
	set_audio_stream_based_on_stars()
	set_buttons()
	display_performance_message()

	# Await the timer's timeout signal
	await get_tree().create_timer(0.2 + 0.8 * score_manager.stars / 3).timeout
	change_background_color()
	if score_manager.stars == 3:
		play_confetti_animation()
	animate_view($UI/Title)
	
	await get_tree().create_timer(0.5).timeout
	animate_notes(score_manager.total_hits, score_manager.total_notes_in_level)
	animate_timing(score_manager.timing_score())

	animate_view($UI/Notes)
	animate_view($UI/Timing)
	
	await get_tree().create_timer(0.5).timeout
	#animate_view($UI/XP)
	#animate_view($UI/Combo)
	#update_xp(0, score_manager.game_score, ANIMATION_DELAY * score_manager.stars)
	#update_combo()
	animate_golden_notes(Game.golden_notes_collected, NotesContainer.golden_notes_in_level)
	await get_tree().create_timer(1).timeout
	animate_view($UI/Buttons)
	

# 

func update_song_stars_results() -> void:
	if Game.song_results[model.get("id",0)].has(Game.current_difficulty):
		if score_manager.stars > Game.song_results[model.get("id",0)][Game.current_difficulty]:
			Game.song_results[model.get("id",0)][Game.current_difficulty] = score_manager.stars
	else:
		Game.song_results[model.get("id",0)][Game.current_difficulty] = score_manager.stars

func animate_golden_notes(hit_notes: int, total_notes: int) -> void:
	var notes_counter: Label = $UI/GoldenNotes/NotesCounter
	golden_notes.visible = true
	notes_counter.text = (str(hit_notes) + " / " + str(total_notes))
	golden_notes.find_child("Fader").fade_in()

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
	
func update_combo() -> void:
	
	var combo_progress: float = float((score_manager.combo_full_hits * int(score_manager.max_combo_mode)) + score_manager.max_hits_in_max_combo) / float(score_manager.combo_full_hits * 4)
	AnimationHelper.play_animation_sprite_until_frame(combo_animation, "default", 2 + combo_progress * 49)
	
	if combo_progress == 1:
		# Find the Expander node and trigger bounce animation
		#var expander: Node = combo_container.find_child("Expander")
		#if expander:
			#expander.expand(1.5, 0.25, true)

		# Change the label text and colors for new high score
		combo_label.text = "מקסימום קומבו!"  # New High Score in Hebrew
		combo_label.add_theme_color_override("font_color", Color("#FFD44F"))

		# Add slide animation for the label text
		#animate_label_slide(combo_label)

func update_xp(start_value: int, end_value: int, duration: float) -> void:

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
		#var expander: Node = xp_container.find_child("Expander")
		#if expander:
			#expander.expand(1.5, 0.25, true)

		# Change the label text and colors for new high score
		xp_label_title.text = "שיא חדש!"  # New High Score in Hebrew
		xp_label_title.add_theme_color_override("font_color", Color("#FFD44F"))
		xp_background.texture = load("res://art/XPBackgroundHighlight.png")
		xp_label.add_theme_color_override("font_color", Color("#200854"))

		# Add slide animation for the label text
		#animate_label_slide(xp_label_title)

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
	AnimationHelper.play_animation_sprite_until_frame(stars_animation, "stars_end_animation" + "_" + Game.current_difficulty, frame)

func set_audio_stream_based_on_stars() -> void:	
	var audio_path: String
	match int(score_manager.stars):
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
