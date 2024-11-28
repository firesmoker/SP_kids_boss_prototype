extends Node
class_name MidiWebSocket

@onready var midiProcessor: MidiProcessor = $"../Midi Processor"

# List of WebSocket servers to connect to
# Static array of server URLs
static var SERVER_URLS: Array[String] = ["ws://h-MacBook-Pro-sl-Simply.local:8099", "ws://Simplys-MacBook-Pro.local:8099", "ws://Alons-Laptop.local:8099"]

var sockets: Array[WebSocketPeer] = []

enum WebSocketMessageList {
	WEBSOCKET_NOTE_OFF = 128,
	WEBSOCKET_NOTE_ON = 144
}

func _ready() -> void:
	# Create and connect a WebSocketPeer for each server
	for server_url: String in SERVER_URLS:
		var socket: WebSocketPeer = WebSocketPeer.new()
		socket.connect_to_url(server_url)
		sockets.append(socket)

func _process(delta: float) -> void:
	for socket: WebSocketPeer in sockets:
		socket.poll()
		var state: int = socket.get_ready_state()
		
		if state == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count() > 0:
				var packet: Variant = socket.get_packet()
				if packet is String:
					print("Packet from %s: %s" % [socket.get_connected_host(), packet])
				elif packet is PackedByteArray:
					print("Packet from %s: %s" % [socket.get_connected_host(), packet])
					process(packet)
				else:
					print("Received unsupported packet type: ", typeof(packet))
		
		elif state == WebSocketPeer.STATE_CLOSING:
			# Keep polling to achieve proper close.
			pass
		
		elif state == WebSocketPeer.STATE_CLOSED:
			var code: int = socket.get_close_code()
			var reason: String = socket.get_close_reason()
			print("WebSocket closed for %s with code: %d, reason: %s. Clean: %s" % 
				  [socket.get_connected_host(), code, reason, code != -1])
			# Remove this socket if it's closed, to avoid processing it further
			sockets.erase(socket)

func process(packet: PackedByteArray) -> void:
	var midi_event: MidiEvent = MidiEvent.new()
	match packet[0]:
		WebSocketMessageList.WEBSOCKET_NOTE_OFF: midi_event.action = "off"
		WebSocketMessageList.WEBSOCKET_NOTE_ON: midi_event.action = "on"
	match packet[2]:
		0: return
		
	midi_event.pitch = packet[1]
	midi_event.velocity = packet[2]
	midiProcessor.processEvent(midi_event)
