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
@onready var piano: Node = $"../../../Sound/Piano"
var piano_streams: Array[AudioStreamPlayer]
var piano_current_stream: int = 0

func _ready() -> void:
	game = NodeHelper.get_root_game(self)
	note_success.connect(game.hit_boss)
	note_success.connect(game.start_score_visual)
	note_failure.connect(game.miss_note)
	construct_piano_streams()

func construct_piano_streams() -> void:
	var piano_children: Array = piano.get_children()
	for stream: AudioStreamPlayer in piano_children:
		piano_streams.append(stream)
	print("piano construction complete")
		

func _unhandled_input(event: InputEvent) -> void:	
	if not bottom_detector and not event.is_echo() and not event.is_released():
		var note: String = event.as_text() + "4"
		note_played(note)
		note = event.as_text() + "5"
		note_played(note)
	elif not event.is_echo() and not event.is_released():
		var note: String = event.as_text() + "3"
		note_played(note)

func note_played(note: String) -> void:
	print("note played: " + note)
	if note == "C4":
		emit_signal("continue_note_played")
	if game.get_lose_state():
		return
		
	var distance: float = 100
	var target_index: int = -1  # Initialize the target index
	var playback_position: float = game.music_player.get_playback_position()

	# Iterate using an index
	for i in current_notes.size():
		var n: Note = current_notes[i]
		if n.note != note:
			continue
			
		var time: float = n.event.time * score_manager.beat_manager.beat_length * 4
		var note_distance: float = abs(time - playback_position)

		# Update target_index if this note is closer
		if note_distance < distance:
			distance = note_distance
			target_index = i

	# Check if a valid target_index was found
	if target_index != -1:
		var target_note: Note = current_notes[target_index]
		note = target_note.note
		note_hit(target_index)

func note_hit(i: int) -> void:
	if game.vulnerable:
		var note_object: Note = current_notes[i]
		hit_notes.append(note_object)
		emit_signal("note_success")
		if Game.cheat_play_piano_sounds:
			play_note_sound(note_object.note)
		print("RIGHT NOTE PLAYED YAY!")
		if game.game_state == "Playing":
			var note_score: float = score_manager.hit(note_object)
			current_notes[i].hit_note_visual(note_score)
			current_notes[i].state = "Played"
			current_notes.pop_at(i)
		

func play_note_sound(note_name: String = "C4") -> void:
	piano_streams[piano_current_stream].stream = load("res://audio/piano_notes/" + note_name + ".ogg")
	piano_streams[piano_current_stream].play()
	piano_current_stream += 1
	if piano_current_stream >= piano_streams.size():
		piano_current_stream = 0

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
