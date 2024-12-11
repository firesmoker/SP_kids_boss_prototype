extends Node
class_name ScoreManager

@onready var beat_manager: BeatManager = $"../Sound/BeatManager"

# Sensitivity factor for scoring
var sensitivity: float = 0.7

# Combo multiplier modes
enum ComboMode { X1, X2, X3, X4 }
var combo_mode: ComboMode = ComboMode.X1
var combo_mode_changed: bool = false
var combo_hits: int = 0  # Tracks hits within the current combo mode
var combo_full_hits: int = 10  # Number of hits required to fully progress the combo mode

# Total score considering combo multipliers
var game_score: float = 0.0  # Score for notes passed so far
var current_score: float = 0.0  # Score relative to all notes in the song
var overall_score: float = 0.0 # Score relative to all notes in the song
var gamified_overall_score: float = 0.0  # Score relative to all notes in the song
var perfect_score: float = 0
var three_stars_score: float = 0
var two_stars_score: float = 0
var one_star_score: float = 0

# Total notes passed and total notes in the level
var total_hits: int = 0
var total_passed_notes: int = 0
var total_notes_in_level: int = 0
var total_net_notes_in_level: int = 0

# Array to track individual note scores
var note_scores: Array = []
var golden_note_scores: float = 0

# Property to calculate stars based on the overall_score
var stars: float = 0.0

# Tracks the current combo streak
var current_combo: int = 0
var max_combo: int = 0

var max_normal_note_score: float = 10


func miss(note: Note) -> void:
	"""
	Handles a missed note. Resets combo and updates scores.
	"""
	total_passed_notes += 1
	add_note_score(0)  # Add a score of 0 for a missed note
	reset_combo()

func miss_golden_note() -> void:
	"""
	Handles a missed note. Resets combo and updates scores.
	"""
	total_passed_notes += 1
	add_note_score(0)  # Add a score of 0 for a missed note
	reset_combo()

func hit(note: Note) -> float:
	"""
	Handles a hit note. Calculates the score, applies the combo multiplier, and updates scores.
	"""
	total_passed_notes += 1
	total_hits += 1
	var time: float = note.event.time * beat_manager.beat_length * 4
	var current_time: float = beat_manager.music_player.get_playback_position()
	var note_score: float = calculate_note_hit_score(time, current_time, beat_manager.beat_length)
	add_note_score(note_score)
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

func add_note_score(note_score: float, golden_note: bool = false) -> void:
	"""
	Adds the note score to the `note_scores` array.
	"""
	
	if golden_note:
		golden_note_scores += note_score
	else:
		note_scores.append(note_score)
	
	var multiplier: int = combo_multiplier()
	# Update scores
	current_score += note_score
	overall_score = current_score / total_notes_in_level
	game_score += round(note_score * multiplier * max_normal_note_score)
	gamified_overall_score = game_score / perfect_score_in_level()
	
	# Update combo streak and hits
	current_combo += 1
	if current_combo > max_combo:
		max_combo = current_combo
	
	combo_hits = min(combo_full_hits, combo_hits + 1)
	combo_mode_changed = false
	if combo_hits >= combo_full_hits and combo_mode != ComboMode.X4:
		combo_mode_changed = true
		advance_combo_mode()
	else:
		combo_mode_changed = false
	
	if Game.score_based_stars:
		calculate_stars_with_combo()
	else:
		calculate_stars()

func perfect_score_in_level() -> float:
	var perfect_max_notes_in_1x: float = combo_full_hits
	var perfect_max_notes_in_2x: float = combo_full_hits
	var perfect_max_notes_in_3x: float = combo_full_hits
	var perfect_max_notes_in_4x: float = total_notes_in_level - (perfect_max_notes_in_1x + perfect_max_notes_in_2x + perfect_max_notes_in_3x)
	if perfect_max_notes_in_4x < 0:
		print("perfect max notes in 4x is 0!")
		perfect_max_notes_in_4x = 0
	return max_normal_note_score*(perfect_max_notes_in_4x * 4 + perfect_max_notes_in_3x * 3 + perfect_max_notes_in_2x * 2 + perfect_max_notes_in_1x * 1)

func three_stars_score_in_level() -> float:
	var max_combo_breaks: int = floor(total_notes_in_level / 100)
	if max_combo_breaks < 1:
		max_combo_breaks = 1
	var notes_in_1x: float = combo_full_hits * (1 + max_combo_breaks)
	var notes_in_2x: float = combo_full_hits * (1 + max_combo_breaks)
	var notes_in_3x: float = combo_full_hits * (1 + max_combo_breaks)
	var notes_in_4x: float = total_notes_in_level - (notes_in_1x + notes_in_2x + notes_in_3x)
	if notes_in_4x < 0:
		print("perfect max notes in 4x is 0!")
		notes_in_4x = 0
	var allowed_missed_notes: int = roundi(total_notes_in_level * 0.05)
	if allowed_missed_notes < max_combo_breaks:
		allowed_missed_notes = max_combo_breaks
	return max_normal_note_score*(notes_in_4x * 4 + notes_in_3x * 3 + notes_in_2x * 2 + notes_in_1x * 1 - allowed_missed_notes)
#
func calculate_stars_with_combo() -> void:
	if gamified_overall_score < Game.star1_threshold_score:
		stars = 0.0
	elif gamified_overall_score < Game.star2_threshold_score:
		stars = 1.0 + (gamified_overall_score - Game.star1_threshold_score) * (1.0 / 0.2) # Linear projection between 1 and 2 stars
	elif gamified_overall_score < Game.star3_threshold_score:
		stars = 2.0 + (gamified_overall_score - Game.star2_threshold_score) * (1.0 / 0.2) # Linear projection between 2 and 3 stars
	else:
		stars = 3.0

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
	score += golden_note_scores
	score = score / total_notes_in_level		
	if score < 0.5:
		stars = 0.0
	elif score <= 0.7:
		stars = 1.0 + (score - 0.5) * (1.0 / 0.2) # Linear projection between 1 and 2 stars
	elif score <= 0.9:
		stars = 2.0 + (score - 0.7) * (1.0 / 0.2) # Linear projection between 2 and 3 stars
	else:
		stars = 3.0

func reset_combo() -> void:
	"""
	Resets the combo mode to X1, combo_hits to 0, and streak to 0.
	"""
	if combo_mode != ComboMode.X1:
		combo_mode = ComboMode.X1
		combo_mode_changed = true
	else:
		combo_mode_changed = false
	combo_hits = 0
	current_combo = 0

func advance_combo_mode() -> void:
	"""
	Advances to the next combo mode and resets combo_hits.
	"""
	if combo_mode < ComboMode.X4:  # Don't advance past X4
		combo_mode += 1
	combo_hits = 0
	
	
func timing_score() -> float:
	if note_scores.size() == 0:
		return 0.0  # Avoid division by zero
		
	var sum: float = 0.0
	var count: float = 0
	for value: float in note_scores:
		if value > 0:
			sum += value
			count += 1
	
	return sum / count
	 
	
# Debugging helper to print scores, stars, and combo
func print_score_details() -> void:
	print("Game Score: ", game_score)
	print("Overall Score: ", overall_score)
	print("Game Score: ", game_score)
	print("Stars: ", stars)
	print("Current Combo: ", current_combo)
	print("Max Combo: ", max_combo)
	print("Combo Mode: ", combo_mode)
	print("Combo Hits: ", combo_hits, "/", combo_full_hits)
	print("Total Passed Notes: ", total_passed_notes, "/", total_notes_in_level)
	print("Note Scores: ", note_scores)
