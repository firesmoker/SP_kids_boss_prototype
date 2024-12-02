extends Node
class_name BeatManager

@onready var music_player: AudioStreamPlayer = $"../MusicPlayer"
var bpm: float = Game.tempo # Set this to the BPM of your music
var beat_length: float = 60.0 / bpm
var next_beat_time: float = beat_length # Time for the next beat signal
var paused: bool = false
var was_playing: bool = false # Track if music was playing in the last frame
var game: Game
signal beat_signal

func _ready() -> void:
	# Connect the finished signal to stop beat tracking when the music ends
	music_player.connect("finished", Callable(self, "_on_music_finished"))

	# Start playing the music
	game = NodeHelper.get_root_game(self)
	music_player.play()
	beat_signal.connect(game.beat_effects)

func _process(delta: float) -> void:
	# Check if the play/pause state has changed
	if music_player.playing != was_playing:
		paused = not music_player.playing
		was_playing = music_player.playing
	
	if music_player.playing and !paused:
		var current_time: float = music_player.get_playback_position()
		
		# Emit beat signal if within delta / 2 of the next beat time or if we've just passed it
		var emit_beat: bool = (abs(current_time - next_beat_time) <= delta)
		if emit_beat or current_time > next_beat_time:
			if emit_beat:
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
