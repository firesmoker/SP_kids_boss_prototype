extends Node
class_name MidiWebSocket

@onready var midiProcessor: MidiProcessor = $"../Midi Processor"
var socket: WebSocketPeer = WebSocketPeer.new()

enum WebSocketMessageList {
	WEBSOCKET_NOTE_OFF = 128,
	WEBSOCKET_NOTE_ON = 144
}

func _ready() -> void:
	socket.connect_to_url("ws://h-MacBook-Pro-sl-Simply.local:8099")

func _process(delta: float) -> void:
	socket.poll()
	var state: int = socket.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count() > 0:
			var packet: Variant = socket.get_packet()
			if packet is String:
				print("Packet: ", packet)  # Packet is already a string
			elif packet is PackedByteArray:
				print("Packet: ", packet)
				process(packet)
			else:
				print("Received unsupported packet type: ", typeof(packet))
	
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	
	elif state == WebSocketPeer.STATE_CLOSED:
		var code: int = socket.get_close_code()
		var reason: String = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason: %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.


func process(packet: PackedByteArray) -> void:
	var midi_event: MidiEvent = MidiEvent.new()
	match packet[0]:
		WebSocketMessageList.WEBSOCKET_NOTE_OFF: midi_event.action = "off"
		WebSocketMessageList.WEBSOCKET_NOTE_ON: midi_event.action = "on"
	midi_event.pitch = packet[1]
	midi_event.velocity = packet[2]
	midiProcessor.processEvent(midi_event)
