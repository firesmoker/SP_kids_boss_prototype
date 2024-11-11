# SettingsManager.gd
extends Node
class_name SettingsManager

# Define the file path for your settings file
const SETTINGS_PATH: String = "user://settings.json"

# Dictionary to store your settings with default values
var settings: Dictionary = {
}

# Load settings when the game starts
func _ready() -> void:
	load_settings()

# Save settings to a JSON file
func save_settings() -> void:
	# Open the file in write mode
	var file: FileAccess = FileAccess.open(SETTINGS_PATH, FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(JSON.stringify(settings))  # Use JSON.stringify to convert dictionary to JSON string
		file.close()
		print("Settings saved to", SETTINGS_PATH)
	else:
		print("Failed to save settings.")

# Load settings from the JSON file
func load_settings() -> void:
	# Check if the file exists before attempting to read
	if FileAccess.file_exists(SETTINGS_PATH):
		# Open the file in read mode
		var file: FileAccess = FileAccess.open(SETTINGS_PATH, FileAccess.ModeFlags.READ)
		if file:
			var data: String = file.get_as_text()
			
			# Create an instance of JSON and parse data
			var json: JSON = JSON.new()
			settings = json.parse_string(data)
			file.close()
			print("Settings loaded from", SETTINGS_PATH)
		else:
			print("Failed to load settings.")
	else:
		print("No settings file found, using default settings.")
