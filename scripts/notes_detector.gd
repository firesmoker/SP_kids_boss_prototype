class_name NotesDetector extends Area2D

var current_notes: Array[Note]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var note_played: String = "G4"
		if current_notes.size() > 0:
			if note_played == current_notes[0].pitch:
				print("RIGHT NOTE PLAYED YAY!")
				current_notes[0].become_giant()
				current_notes[0].state = "Played"
				current_notes.pop_at(0)
				
			else:
				print("wrong note played YA LOSER")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		current_notes.pop_front()
	elif note.state == "inactive":
		print("inactive note left")
