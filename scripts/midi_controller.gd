extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.open_midi_inputs()
	print("MIDI Inputs:")
	print(OS.get_connected_midi_inputs())

	for current_midi_input in OS.get_connected_midi_inputs():
		print(current_midi_input)

# Enum for MIDI message types
enum GlobalScope_MidiMessageList {
	MIDI_MESSAGE_NOTE_OFF = 0x8,
	MIDI_MESSAGE_NOTE_ON = 0x9,
	MIDI_MESSAGE_AFTERTOUCH = 0xA,
	MIDI_MESSAGE_CONTROL_CHANGE = 0xB,
	MIDI_MESSAGE_PROGRAM_CHANGE = 0xC,
	MIDI_MESSAGE_CHANNEL_PRESSURE = 0xD,
	MIDI_MESSAGE_PITCH_BEND = 0xE,
}

const MIDI_EVENT_PROPERTIES: Array = ["channel", "message", "pitch", "velocity", "instrument", "pressure", "controller_number", "controller_value"]

func get_midi_message_description(event: InputEventMIDI) -> String:
	if event.message in GlobalScope_MidiMessageList.values():
		return GlobalScope_MidiMessageList.keys()[event.message - 0x08]
	return str(event.message)

const OCTAVE_KEY_INDEX: Array = ["C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4"]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		var event_dump: String = ""

		event_dump += "event: {0}\n".format([get_midi_message_description(event)])

		for current_property: String in MIDI_EVENT_PROPERTIES:
			event_dump += "  {0}: {1}\n".format([current_property, event.get(current_property)])

		event_dump += "\n"

		var key_index: int = event.pitch % 12

		match event.message:
			GlobalScope_MidiMessageList.MIDI_MESSAGE_NOTE_ON:
				print("MIDI Key On: " + OCTAVE_KEY_INDEX[key_index])

			GlobalScope_MidiMessageList.MIDI_MESSAGE_NOTE_OFF:
				print("MIDI Key Off: " + OCTAVE_KEY_INDEX[key_index])
