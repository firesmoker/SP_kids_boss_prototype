class_name NotesDetector extends Area2D
@onready var game: Game
@export var bottom_detector: bool = false
var current_notes: Array[Note]

signal note_success
signal note_failure

func _ready() -> void:
	game = get_tree().root.get_child(0)
	note_success.connect(game.hit_boss)
	note_success.connect(game.add_to_combo)
	note_failure.connect(game.break_combo)
	

func _unhandled_input(event: InputEvent) -> void:	
	if not bottom_detector and not event.is_echo() and not event.is_released():
		var note: String = event.as_text() + "4"
		note_played(note)
	elif not event.is_echo() and not event.is_released():
		var note: String = event.as_text() + "3"
		note_played(note)

func note_played(note: String) -> void:
	var interval: bool = false
	if current_notes.size() > 1 and not game.get_lose_state():
		if current_notes[0].position.x == current_notes[1].position.x:
			interval = true
			
	if current_notes.size() > 0 and not game.get_lose_state():
		if interval:
			for i in range(clamp(current_notes.size(),1,2)):
				if note == current_notes[i].note:
					emit_signal("note_success")
					print("RIGHT NOTE PLAYED YAY!")
					if game.game_state == "Playing":
						current_notes[i].hit_note_visual()
						current_notes[i].state = "Played"
						current_notes.pop_at(i)
					break
		elif note == current_notes[0].note:
			emit_signal("note_success")
			print("RIGHT NOTE PLAYED YAY!")
			if game.game_state == "Playing":
				current_notes[0].hit_note_visual()
				current_notes[0].state = "Played"
				current_notes.pop_at(0)
		
			
			
		#else:
			#print("wrong note played YA LOSER")

func clear_notes() -> void:
	current_notes.clear()

func _on_body_entered(note: Note) -> void:
	if note.state == "Active":
		current_notes.append(note)
		if Game.cheat_auto_play:
			note_played(note.note)
	elif note.state == "Rest":
		#print("yay rest")
		pass
	else:
		#print("INACTIVE NOTE ENTERED!!!")
		pass
	#print(current_notes)


func _on_body_exited(note: Note) -> void:
	if note.state == "Active":
		note.miss_note_visual()
		current_notes.pop_front()
		emit_signal("note_failure")
	elif note.state == "inactive":
		print("inactive note left")
