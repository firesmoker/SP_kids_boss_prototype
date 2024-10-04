extends Node
class_name MidiProcessor

@onready var notes_detector: NotesDetector = $"../../Level/RightHandPart/NotesDetector"

const OCTAVE_KEY_INDEX: Array = ["C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func processEvent(event: MidiEvent) -> void:
	
	var key_index: int = event.pitch % 12
	var note: String = OCTAVE_KEY_INDEX[key_index]
	match event.action:
		"on":
			print("MIDI: " + event.as_string())
			notes_detector.note_played(note)

		"off":
			pass
