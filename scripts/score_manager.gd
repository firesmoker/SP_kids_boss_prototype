extends Node
class_name ScoreManager

@onready var beat_manager: BeatManager = $"../Sound/BeatManager"

# Sensitivity factor for scoring
var sensitivity: float = 0.5

# Array to hold Note nodes
var note_scores: Array = []

# Weighted average of Note scores (0 to 1)
var overall_score: float = 0.0

# Property to calculate stars based on the overall_score
var stars: float = 0.0

func miss(note: Note) -> void:
	add_note_score(0)

func hit(note: Note) -> void:
	var time: float = note.event.time * beat_manager.beat_length * 4
	var current_time: float = beat_manager.music_player.get_playback_position()
	
	var note_score: float = calculate_note_hit_score(time, current_time, beat_manager.beat_length)
	add_note_score(note_score)


# Define a non-linear scoring function using an exponential decay
func score_function(time_difference: float, beat_length: float, sensitivity: float) -> float:
	return max(0, exp(-pow(time_difference / (beat_length * sensitivity), 2)))

func calculate_note_hit_score(note_time: float, current_time: float, beat_length: float) -> float:
	# Calculate the absolute time difference
	var time_difference: float = abs(note_time - current_time)

	# Calculate the score based on the time difference
	return score_function(time_difference, beat_length, sensitivity)

func add_note_score(note_score: float) -> void:
	"""
	Adds a new Note score to the notes array.
	note_score should be a value between 0 and 1.
	"""
	print("Note score: " + str(note_score))
	note_scores.append(note_score)
	calculate_overall_score()
	calculate_stars()

func calculate_overall_score() -> void:
	"""
	Calculates the weighted average of the scores.
	"""
	if note_scores.size() == 0:
		overall_score = 0.0
	else:
		var total_score: float = 0.0
		for score: float in note_scores:
			total_score += score
		overall_score = total_score / note_scores.size()

func calculate_stars() -> void:
	"""
	Calculates the star rating based on the overall_score.
	"""
	if overall_score <= 0.5:
		stars = 1.0
	elif overall_score <= 0.7:
		stars = 1.0 + (overall_score - 0.5) * (1.0 / 0.2) # Linear projection between 1 and 2 stars
	elif overall_score <= 0.9:
		stars = 2.0 + (overall_score - 0.7) * (1.0 / 0.2) # Linear projection between 2 and 3 stars
	else:
		stars = 3.0

# Debugging helper to print scores and stars
func print_score_details() -> void:
	print("Notes: ", note_scores)
	print("Overall Score: ", overall_score)
	print("Stars: ", stars)
