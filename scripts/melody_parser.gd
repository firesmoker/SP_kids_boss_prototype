extends Node

var melody_events: Array[MelodyEvent]

# Structure for parsed melody events
class MelodyEvent:
	var note: String = "" 
	var duration: float = 0.0 
	var finger: int = 0
	var event_type: String = "" 
	
	func as_string() -> String: # Function returns String
		var result: String = "MelodyEvent: " # String
		result += "Duration: " + str(duration) + ", "
		result += ("Note: " + note + ", " if note != null else "")
		result += ("Finger: " + str(finger) + ", " if finger != null else "")
		result += ("Event Type: " + event_type + ", " if event_type != null else "")
		return result
			
# Function to parse the melody string
func parse_melody(melody_string: String) -> Array: # Input is a String, output is an Array
	var melody_array: Array = [] # Array to hold events
	var current_time: float = 0.0 # float to track time
	var sections: Array = melody_string.split(" ") # Array of Strings (split by space)
	
	for section: String in sections:
		var event: MelodyEvent = MelodyEvent.new() # MelodyEvent instance
		
		# Parse CriticalSectionStart and CriticalSectionEnd events
		if section.begins_with("*CriticalSectionStart:*"):
			event.event_type = "CriticalSectionStart"
			melody_array.append({"time": current_time, "event": event}) # Dictionary entry
			continue
		elif section.begins_with("*CriticalSectionEnd:*"):
			event.event_type = "CriticalSectionEnd"
			melody_array.append({"time": current_time, "event": event}) # Dictionary entry
			continue
		
		# Parse pauses or notes
		var parts: Array = section.split(":") # Array of Strings (split by colon)
		var note_or_pause: String = parts[0] # String for note or pause
		var details: Array = parts[1].split("%") # Array of Strings (split by '%')
		
		# Parse duration
		var duration: float = parse_fraction_as_float(details[0]) # Parse duration as float
		
		# Update the event details
		if note_or_pause == "-":
			event.note = "rest"
		else:
			event.note = note_or_pause
		
		event.duration = duration
		
		# Parse finger number if present
		if details.size() > 1:
			event.finger = int(details[1]) # finger is an int, but stored as String
		
		# Add the event to the melody array with the current time
		melody_array.append({"time": current_time, "event": event}) # Dictionary entry
		# Update the current time
		current_time += duration

	return melody_array

func parse_fraction_as_float(fraction_string: String) -> float: # Input is String, output is float
	var parts: Array = fraction_string.split("/") # Split fraction into parts
	var numerator: float = 0.0 # float for numerator
	var denominator: float = 1.0 # float for denominator
	if parts.size() > 0:
		numerator = float(parts[0])
	if parts.size() > 1:
		denominator = float(parts[1])
	return numerator / denominator

func read_text_file(file_path: String) -> String:
	var file_access: FileAccess = FileAccess.open(file_path, FileAccess.READ)  # Open the file for reading
	var contents: String
	if file_access != null:
		contents = file_access.get_as_text()  # Read the contents as text
		file_access.close()  # Close the file after reading
	else:
		print("Failed to open file.")
	return contents
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void: # Function returns void
	print("Ready called for: ", self.name)
	var file_content: String = read_text_file("res:///levels/melody1.txt")
	parse_melody(file_content)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: # Function takes float, returns void
	pass
