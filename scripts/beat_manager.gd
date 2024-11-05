extends Node
class_name BeatManager

@onready var music_player: AudioStreamPlayer = $"../MusicPlayer"
var bpm: float = Game.tempo # Set this to the BPM of your music
var beat_length: float = 60.0 / bpm
var next_beat_time: float = beat_length # Time for the next beat signal
var paused: bool = false
var game: Game
signal beat_signal

func _ready() -> void:
	# Connect the finished signal to stop beat tracking when the music ends
	music_player.connect("finished", Callable(self, "_on_music_finished"))
	music_player.connect("playing_changed", Callable(self, "_on_playing_changed"))

	# Start playing the music
	music_player.play()
	
	game = get_tree().root.get_child(0)
	beat_signal.connect(game.beat_effects)

func _process(delta: float) -> void:
	if music_player.playing and !paused:
		var current_time: float = music_player.get_playback_position()
		
		# Check if the current playback position has passed the time for the next beat
		if current_time >= next_beat_time:
			print("beat_marker " + str(current_time))
			emit_signal("beat_signal")
			
			# Calculate the time for the next beat
			next_beat_time += beat_length
			
			# Handle cases where the current time skips ahead (e.g., seeking)
			while current_time >= next_beat_time:
				next_beat_time += beat_length

func _on_music_finished() -> void:
	# Reset the next beat time when the music finishes
	next_beat_time = beat_length

func _on_playing_changed() -> void:
	paused = not music_player.playing
