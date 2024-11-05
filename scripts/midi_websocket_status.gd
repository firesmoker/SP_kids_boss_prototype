extends Node

@onready var midiStatusLabel: Label = $"../UI/Midi Status Label"

# List of WebSocket server URLs

var sockets: Array[WebSocketPeer] = []

func _ready() -> void:
	# Create and connect a WebSocketPeer for each server URL
	for url in MidiWebSocket.SERVER_URLS:
		var socket: WebSocketPeer = WebSocketPeer.new()
		socket.connect_to_url(url)
		sockets.append(socket)

func _process(delta: float) -> void:
	var any_connected: bool = false
	
	# Poll and check the connection state for each WebSocketPeer
	for socket in sockets:
		socket.poll()
		var state: int = socket.get_ready_state()
		
		if state == WebSocketPeer.STATE_OPEN:
			any_connected = true
	
	# Update the midiStatusLabel based on the connection state of all servers
	if any_connected:
		midiStatusLabel.text = "מחובר"
		midiStatusLabel.add_theme_color_override("font_color", Color.GREEN)
	else:
		midiStatusLabel.text = "לא מחובר"
		midiStatusLabel.add_theme_color_override("font_color", Color.RED)
