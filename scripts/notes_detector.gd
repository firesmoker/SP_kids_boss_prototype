class_name NotesDetector extends Area2D
@onready var game: Game
@onready var score_manager: ScoreManager = $"../../../ScoreManager"
@export var bottom_detector: bool = false
var current_notes: Array[Note]
var hit_notes: Array[Note]
var missed_notes: Array[Note]
signal note_success
signal note_failure
signal continue_note_played

func _ready() -> void:
	game = get_tree().root.get_child(0)
	note_success.connect(game.hit_boss)
	note_success.connect(game.add_to_combo)
	note_failure.connect(game.break_combo)
	note_failure.connect(game.miss_note)
	

func _unhandled_input(event: InputEvent) -> void:	
	if not bottom_detector and not event.is_echo() and not event.is_released():
		var note: String = event.as_text() + "4"
		note_played(note)
	elif not event.is_echo() and not event.is_released():
		var note: String = event.as_text() + "3"
		note_played(note)

func note_played(note: String) -> void:
	if note == "C4":
		emit_signal("continue_note_played")
	var interval: bool = false
	if current_notes.size() > 1 and not game.get_lose_state():
		if current_notes[0].position.x == current_notes[1].position.x:
			interval = true
			
	if current_notes.size() > 0 and not game.get_lose_state():
		if interval:
			for i in range(clamp(current_notes.size(),1,2)):
				if note == current_notes[i].note:
					note_hit(i)
					break
		elif note == current_notes[0].note:
			note_hit(0)
			
			
		#else:
			#print("wrong note played YA LOSER")

func note_hit(i: int) -> void:
	if game.vulnerable:
		var note_object: Note = current_notes[i]
		hit_notes.append(note_object)
		emit_signal("note_success")
		print("RIGHT NOTE PLAYED YAY!")
		if game.game_state == "Playing":
			score_manager.hit(note_object)
			current_notes[i].hit_note_visual()
			current_notes[i].state = "Played"
			current_notes.pop_at(i)
		

func clear_notes() -> void:
	current_notes.clear()
	hit_notes.clear()
	missed_notes.clear()

func _on_body_entered(note: Note) -> void:
	if note.state == "Active":
		current_notes.append(note)
		if Game.cheat_auto_play and not game.winning:
			note_played(note.note)
	elif note.state == "Rest":
		#print("yay rest")
		pass
	else:
		#print("INACTIVE NOTE ENTERED!!!")
		pass
	#print(current_notes)


func _on_body_exited(note: Note) -> void:
	if note.state == "Active" and game.vulnerable:
		score_manager.miss(note)
		note.miss_note_visual()
		current_notes.pop_front()
		missed_notes.append(note)
		emit_signal("note_failure")
	elif note.state == "inactive":
		print("inactive note left")
