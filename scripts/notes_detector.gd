class_name NotesDetector extends Area2D
@onready var game: Game
@export var bottom_detector: bool = false
var current_notes: Array[Note]

signal note_success

func _ready() -> void:
	game = get_tree().root.get_child(0)
	note_success.connect(game.hit_boss)

func _unhandled_input(event: InputEvent) -> void:	
	if not bottom_detector:
		var note: String = event.as_text() + "4"
		note_played(note)
	else:
		var note: String = event.as_text() + "3"
		note_played(note)

func note_played(note: String) -> void: 
	if current_notes.size() > 0 and not game.get_lose_state():
		if note == current_notes[0].event.note:
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
	elif note.state == "inactive":
		print("inactive note left")
