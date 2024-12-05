extends Node
class_name ScoreManager

@onready var beat_manager: BeatManager = $"../Sound/BeatManager"

# Sensitivity factor for scoring
var sensitivity: float = 0.7

# Combo multiplier modes
enum ComboMode { X1, X2, X3, X4 }
var combo_mode: ComboMode = ComboMode.X1
var combo_hits: int = 0  # Tracks hits within the current combo mode
var combo_full_hits: int = 10  # Number of hits required to fully progress the combo mode

# Total score considering combo multipliers
var game_score: float = 0.0  # Score for notes passed so far
var current_score: float = 0.0  # Score for notes passed so far
var overall_score: float = 0.0  # Score relative to all notes in the song

# Total notes passed and total notes in the level
var total_passed_notes: int = 0
var total_notes_in_level: int = 0

# Array to track individual note scores
var note_scores: Array = []

# Property to calculate stars based on the overall_score
var stars: float = 0.0

# Tracks the current combo streak
var current_combo: int = 0
var max_combo: int = 0

func miss(note: Note) -> void:
	"""
	Handles a missed note. Resets combo and updates scores.
	"""
	total_passed_notes += 1
	add_note_score(0)  # Add a score of 0 for a missed note
	reset_combo()
	calculate_stars()

func hit(note: Note) -> float:
	"""
	Handles a hit note. Calculates the score, applies the combo multiplier, and updates scores.
	"""
	total_passed_notes += 1
	var time: float = note.event.time * beat_manager.beat_length * 4
	var current_time: float = beat_manager.music_player.get_playback_position()
	var note_score: float = calculate_note_hit_score(time, current_time, beat_manager.beat_length)
	add_note_score(note_score)
	apply_combo(note_score)
	calculate_stars()
	return note_score

# Define a non-linear scoring function using an exponential decay
func score_function(time_difference: float, beat_length: float, sensitivity: float) -> float:
	return max(0, exp(-pow(time_difference / (beat_length * sensitivity), 2)))

func calculate_note_hit_score(note_time: float, current_time: float, beat_length: float) -> float:
	# Calculate the absolute time difference
	var time_difference: float = abs(note_time - current_time)

	# Calculate the score based on the time difference
	return score_function(time_difference, beat_length, sensitivity)

func combo_progress() -> float:
	return float(combo_hits) / float(combo_full_hits)

func combo_multiplier() -> int:
	var multiplier: int = 1
	match combo_mode:
		ComboMode.X1:
			multiplier = 1
		ComboMode.X2:
			multiplier = 2
		ComboMode.X3:
			multiplier = 3
		ComboMode.X4:
			multiplier = 4
	return multiplier

func add_note_score(note_score: float) -> void:
	"""
	Adds the note score to the `note_scores` array.
	"""
	note_scores.append(note_score)

func apply_combo(note_score: float) -> void:
	"""
	Applies the combo multiplier to the note score and updates the combo mode and streak.
	"""
	var multiplier: int = combo_multiplier()
	# Update scores
	game_score += round(note_score * multiplier * 10)
	current_score = game_score / total_passed_notes
	overall_score = game_score / total_notes_in_level  # Normalize for all notes
	
	# Update combo streak and hits
	current_combo += 1
	if current_combo > max_combo:
		max_combo = current_combo
	
	combo_hits += 1
	if combo_hits >= combo_full_hits:
		advance_combo_mode()

func reset_combo() -> void:
	"""
	Resets the combo mode to X1, combo_hits to 0, and streak to 0.
	"""
	combo_mode = ComboMode.X1
	combo_hits = 0
	current_combo = 0

func advance_combo_mode() -> void:
	"""
	Advances to the next combo mode and resets combo_hits.
	"""
	if combo_mode < ComboMode.X4:  # Don't advance past X4
		combo_mode += 1
	combo_hits = 0

func calculate_stars() -> void:
	"""
	Calculates the star rating based on the overall note_scores average.
	"""
	if note_scores.size() == 0:
		stars = 0.0
		return

	var score: float = 0.0
	for s: float in note_scores:
		score += s
	score = score / total_notes_in_level		
	if score < 0.5:
		stars = 0.0
	elif score <= 0.7:
		stars = 1.0 + (score - 0.5) * (1.0 / 0.2) # Linear projection between 1 and 2 stars
	elif score <= 0.9:
		stars = 2.0 + (score - 0.7) * (1.0 / 0.2) # Linear projection between 2 and 3 stars
	else:
		stars = 3.0

# Debugging helper to print scores, stars, and combo
func print_score_details() -> void:
	print("Current Score: ", current_score)
	print("Overall Score: ", overall_score)
	print("Game Score: ", game_score)
	print("Stars: ", stars)
	print("Current Combo: ", current_combo)
	print("Max Combo: ", max_combo)
	print("Combo Mode: ", combo_mode)
	print("Combo Hits: ", combo_hits, "/", combo_full_hits)
	print("Total Passed Notes: ", total_passed_notes, "/", total_notes_in_level)
	print("Note Scores: ", note_scores)
