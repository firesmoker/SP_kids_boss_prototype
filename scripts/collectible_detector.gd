class_name CollectibleDetector extends Area2D
@onready var game: Game

var current_collectibles: Array[Collectible]
signal collectible_collected

func _ready() -> void:
	game = get_tree().root.get_child(0)
	collectible_collected.connect(game.activate_effect)

func _unhandled_input(event: InputEvent) -> void:	
	var note: String = event.as_text() + "4"
	collect_by_note(note)

func collect_by_note(note: String) -> void: 
	if current_collectibles.size() > 0:
		if note == current_collectibles[0].event.note:
			var effect: String = current_collectibles[0].event.subtype
			emit_signal("collectible_collected", effect)
			print("RIGHT COLLECTIBLE NOTE!")
			if game.game_state == "Playing":
				current_collectibles[0].find_child("Fader").expand_fade_out()
				current_collectibles[0].state = "Inactive"
				#current_collectibles[0].visible = false
				current_collectibles.pop_at(0)
			
			
		else:
			print("wrong note played YA LOSER")

func clear_collectibles() -> void:
	current_collectibles.clear()

func _on_body_entered(collectible: Collectible) -> void:
	if collectible.state == "Active":
		current_collectibles.append(collectible)

func _on_body_exited(collectible: Collectible) -> void:
	if collectible.state == "Active":
		current_collectibles.pop_front()
