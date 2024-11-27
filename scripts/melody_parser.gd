class_name Parser extends Node

var melody_events: Array[MelodyEvent]

# Function to parse the melody string
func parse_melody(melody_string: String) -> Array[MelodyEvent]: # Input is a String, output is an Array
	var melody_array: Array[MelodyEvent] = [] # Array to hold events
	var current_time: float = 0.0 # float to track time
	melody_string = melody_string.strip_edges()
	melody_string = melody_string.replace("\n", " ").replace("\t", " ")
	melody_string = " ".join(melody_string.split(" ", false)) # Replace consecutive spaces with a single space
	var sections: Array = melody_string.split(" ") # Array of Strings (split by space)
	for section: String in sections:
		var event: MelodyEvent = MelodyEvent.new() # MelodyEvent instance
		var duration: float = 0
		event.time = current_time
		section = section.strip_edges()
		var parts: PackedStringArray = section.split(":") 
		var note: String = ""
		var extraData: PackedStringArray = []

		if section.contains("Clef") || section.contains("bgmFileName"):
			continue
			
		# Parse milestones (like CriticalSectionStart/End)
		if section.begins_with("*") and section.ends_with(":*"):
			event.type = "milestone"
			section = section.replace("*", "").replace(":", "")
		
		elif section.begins_with("-"):
			event.type = "rest"
			section = section.replace("-", "")
		
		elif section.contains("&&"):
			var collectible_parts: PackedStringArray = parts[0].split("&") 
			event.type = "collectible"
			event.subtype = get_word(collectible_parts[1])
			note = get_word(collectible_parts[0])
		
		else:
			event.type = "note"
			note = get_word(parts[0])
			if note.is_empty():
				continue
				
	
		event.note = note
		
		if parts.size() > 1:
			extraData = parts[1].split("%")
			if extraData.size() > 0:
				duration = parse_fraction_as_float(extraData[0]) # Parse duration as float
			if extraData.size() > 1:
				event.details["finger"] = get_word(extraData[1]) # finger is an int, but stored as String

		# Find the indices of the brackets
		var start_index: int = section.find("[") + 1
		var end_index: int = section.find("]")
		# Extract the word inside the brackets
		if start_index > 0 and end_index > start_index:
			event.details["action"] = section.substr(start_index, end_index - start_index).strip_edges()
				
		event.duration = duration
		
		# Add the event to the melody array with the current time
		melody_array.append(event) # Dictionary entry
		# Update the current time
		current_time += duration

	return melody_array

func get_word(input: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("^[\\w]+")  # Match one or more alphanumeric characters at the start
	var match: RegExMatch = regex.search(input)
	if match:
		return match.strings[0].strip_edges()  # Return the matched string
	return ""
	
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

func get_melody_array_by_file(file_path: String) -> Array:
	print("Ready called for: ", self.name)
	var file_content: String = read_text_file(file_path)
	melody_events = parse_melody(file_content)
	return melody_events

func print_melody_events(events: Array[MelodyEvent]) -> void:
	for event: MelodyEvent in events:
		print(event.as_string())
