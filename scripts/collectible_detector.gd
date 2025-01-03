class_name CollectibleDetector extends Area2D
@onready var game: Game

@export var bottom_detector: bool = false
var current_collectibles: Array[CollectibleMarker]
signal collectible_collected
signal collectible_completed
signal golden_note_missed
signal golden_note_success

func _ready() -> void:
	game = NodeHelper.get_root_game(self)
	collectible_collected.connect(game.activate_effect)
	collectible_completed.connect(game.deactivate_effect)
	golden_note_missed.connect(game.get_hit)
	golden_note_missed.connect(game.golden_note_missed)
	if Game.game_mode == "library":
		golden_note_success.connect(game.start_score_visual)
	

func _unhandled_input(event: InputEvent) -> void:	
	if event.is_pressed() and not event.is_echo():
		if not bottom_detector:
			var note: String = event.as_text() + "4"
			note_played(note)
		else:
			var note: String = event.as_text() + "3"
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
				if current_collectibles[0].event.subtype == "golden_note":
					print(" golden noteeeee ")
					emit_signal("golden_note_success")
					current_collectibles[0].hit_golden_note_visual()
					game.start_score_visual()
					#game.update_combo_meter()
					#current_collectibles[0].find_child("Fader").fade_out()
				else:
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
			if Game.cheat_auto_play and not game.winning:
				note_played(collectible.note)
	elif collectible is CollectibleMarker:
		var event: MelodyEvent = collectible.event
		var details: Dictionary = event.details
		if details.has("action") and details["action"] == "end":
			emit_signal("collectible_completed", event.subtype)

func _on_body_exited(collectible: CollectibleMarker) -> void:
	if collectible is Collectible:
		if collectible.state == "Active":
			current_collectibles.pop_front()
			if collectible.event.subtype == "golden_note":
				print("missed golden note on body exit")
				emit_signal("golden_note_missed")
				#game.update_combo_meter()
