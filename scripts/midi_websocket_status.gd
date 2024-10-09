extends Node

var socket: WebSocketPeer = WebSocketPeer.new()
@onready var midiStatusLabel: Label = $"../UI/Midi Status Label"

func _ready() -> void:
	socket.connect_to_url("ws://h-MacBook-Pro-sl-Simply.local:8099")

func _process(delta: float) -> void:
	socket.poll()
	var state: int = socket.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		midiStatusLabel.text = "מחובר"
		midiStatusLabel.add_theme_color_override("font_color", Color.GREEN)
	
	elif state == WebSocketPeer.STATE_CLOSING:
		midiStatusLabel.text = "לא מחובר"
		midiStatusLabel.add_theme_color_override("font_color", Color.RED)
	
	elif state == WebSocketPeer.STATE_CLOSED:
		midiStatusLabel.text = "לא מחובר"
		midiStatusLabel.add_theme_color_override("font_color", Color.RED)
