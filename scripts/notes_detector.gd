class_name NotesDetector extends Area2D
@onready var game: Game = $".."

var current_notes: Array[Note]

signal note_success

func _ready() -> void:
	note_success.connect(game.hit_boss)

func _unhandled_input(event: InputEvent) -> void:	
	var note_played: String = event.as_text() + "4"
	print(note_played)
	if current_notes.size() > 0:
		if note_played == current_notes[0].pitch:
			emit_signal("note_success")
			print("RIGHT NOTE PLAYED YAY!")
			if game.game_state == "Playing":
				current_notes[0].hit_note_visual()
				current_notes[0].state = "Played"
				current_notes.pop_at(0)
			
			
		else:
			print("wrong note played YA LOSER")


func clear_notes() -> void:
	current_notes.clear()

func _on_body_entered(note: Note) -> void:
	if note.state == "Active":
		current_notes.append(note)
	elif note.state == "Rest":
		print("yay rest")
	else:
		print("INACTIVE NOTE ENTERED!!!")
	#print(current_notes)


func _on_body_exited(note: Note) -> void:
	if note.state == "Active":
		note.miss_note_visual()
		current_notes.pop_front()
	elif note.state == "inactive":
		print("inactive note left")
