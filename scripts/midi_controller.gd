extends Node
class_name MidiController 

@onready var midiProcessor: MidiProcessor = $"../Midi Processor"
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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		var midi_event: MidiEvent = MidiEvent.new()
		for current_property: String in MIDI_EVENT_PROPERTIES:
			match current_property:
				"pitch": midi_event.pitch = event.get(current_property)
				"velocity": midi_event.velocity = event.get(current_property)
				"message": match event.get(current_property):
					GlobalScope_MidiMessageList.MIDI_MESSAGE_NOTE_ON: midi_event.action = "on"
					GlobalScope_MidiMessageList.MIDI_MESSAGE_NOTE_OFF: midi_event.action = "off"
		midiProcessor.processEvent(midi_event)
