extends Node
class_name MidiProcessor

@onready var notes_detector: NotesDetector = $"../../Level/RightHandPart/NotesDetector"
@onready var bottom_notes_detector: NotesDetector = $"../../Level/RightHandPart/BottomNotesDetector"
@onready var collect_detect: CollectibleDetector = $"../../Level/RightHandPart/CollectDetect"
@onready var bottom_collect_detect: CollectibleDetector = $"../../Level/RightHandPart/BottomCollectDetect"

# List to store all note detectors
@onready var note_detectors: Array = [notes_detector, bottom_notes_detector, collect_detect, bottom_collect_detect]

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
			# Call note_played on all detectors in the list
			for detector: Node in note_detectors:
				detector.note_played(note)

		"off":
			pass
