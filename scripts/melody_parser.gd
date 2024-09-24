class_name Parser extends Node

var melody_events: Array[MelodyEvent]


			
		
func parse_melody(melody_string: String) -> Array[MelodyEvent]:
	var melody_array: Array[MelodyEvent] = []
	var current_time: float = 0.0
	var sections: Array = melody_string.split(" ")
	
	for section: String in sections:
		var event: MelodyEvent = MelodyEvent.new()
		var duration: float = 0
		event.time = current_time
		
		if section.begins_with("*CriticalSectionStart:*"):
			event.event_type = "CriticalSectionStart"
		elif section.begins_with("*CriticalSectionEnd:*"):
			event.event_type = "CriticalSectionEnd"
		else:
			var parts: Array = section.split(":")
			var note_or_pause: String = parts[0]
			var details: Array = parts[1].split("%")
			
			duration = parse_fraction_as_float(details[0]) # Parse duration as float
			
			if note_or_pause == "-":
				event.note = "rest"
			else:
				event.note = note.strip_edges()
			
			event.duration = duration
			
			# Parse finger number if present
			if details.size() > 1:
				event.finger = int(details[1]) # finger is an int, but stored as String
		
		melody_array.append(event)
		current_time += duration

	return melody_array

func parse_fraction_as_float(fraction_string: String) -> float:
	var parts: Array = fraction_string.split("/")
	var numerator: float = 0.0
	var denominator: float = 1.0
	if parts.size() > 0:
		numerator = float(parts[0])
	if parts.size() > 1:
		denominator = float(parts[1])
	return numerator / denominator

func read_text_file(file_path: String) -> String:
	var file_access: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var contents: String
	if file_access != null:
		contents = file_access.get_as_text()
		file_access.close()
	else:
		print("Failed to open file.")
	return contents
	
	
func _ready() -> void:
	print("Ready called for: ", self.name)
	var file_content: String = read_text_file("res:///levels/melody1.txt")
	melody_events = parse_melody(file_content)
	#for event in melody_events:
		#print(event.as_string())
	pass
	
func _process(delta: float) -> void:
	pass

func get_melody_array_by_file(file_path: String) -> Array:
	print("Ready called for: ", self.name)
	var file_content: String = read_text_file(file_path)
	melody_events = parse_melody(file_content)
	return melody_events
