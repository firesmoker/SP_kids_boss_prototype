class_name CollectibleDetector extends Area2D
@onready var game: Game

var current_collectibles: Array[CollectibleMarker]
signal collectible_collected
signal collectible_completed

func _ready() -> void:
	game = get_tree().root.get_child(0)
	collectible_collected.connect(game.activate_effect)
	collectible_completed.connect(game.deactivate_effect)

func _unhandled_input(event: InputEvent) -> void:	
	var note: String = event.as_text() + "4"
	note_played(note)

func note_played(note: String) -> void: 
	if current_collectibles.size() > 0 and not game.get_lose_state():
		var event: MelodyEvent = current_collectibles[0].event
		if note == event.note:
			var effect: String = event.subtype
			var details: Dictionary = event.details
			emit_signal("collectible_collected", effect, details)
			print("RIGHT COLLECTIBLE NOTE!")
			if game.game_state == "Playing":
				current_collectibles[0].play_animation(effect)
				current_collectibles[0].find_child("Fader").expand_fade_out(0.5)
				current_collectibles[0].state = "Inactive"
				#current_collectibles[0].visible = false
				current_collectibles.pop_at(0)
			
			
		#else:
			#print("wrong note played YA LOSER")

func clear_collectibles() -> void:
	current_collectibles.clear()

func _on_body_entered(collectible: CollectibleMarker) -> void:
	if collectible is Collectible:
		if collectible.state == "Active":
			current_collectibles.append(collectible)
	elif collectible is CollectibleMarker:
		var event: MelodyEvent = collectible.event
		var details: Dictionary = event.details
		if details.has("action") and details["action"] == "end":
			emit_signal("collectible_completed", event.subtype)

func _on_body_exited(collectible: CollectibleMarker) -> void:
	if collectible is Collectible:
		if collectible.state == "Active":
			current_collectibles.pop_front()
