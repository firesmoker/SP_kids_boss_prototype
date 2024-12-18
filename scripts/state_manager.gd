extends Node

class_name StateManager

var prefix_mapping: Dictionary = {
	"res": "res://",
	"user": "user://",
	"tmp": "tmp://"
}

# Load state, prioritizing user:// and falling back to res:// or tmp://
func load_state(path: String) -> Dictionary:
	var user_path: String = get_full_path(path, "user")
	var res_path: String = get_full_path(path, "res")
	var tmp_path: String = get_full_path(path, "tmp")

	# Try to load from user:// first
	if FileAccess.file_exists(user_path):
		return load_from_path(user_path)

	# Fallback to res://
	if FileAccess.file_exists(res_path):
		return load_from_path(res_path)

	# Fallback to tmp://
	if FileAccess.file_exists(tmp_path):
		return load_from_path(tmp_path)

	print("State file not found in user://, res://, or tmp://")
	return {}

# Save (update) state to user:// or tmp:// based on permissions
func save_state(path: String, data: Dictionary) -> void:
	var user_path: String = get_full_path(path, "user")
	var tmp_path: String = get_full_path(path, "tmp")

	# On mobile, request permissions before saving to user://
	if OS.has_feature("Android"):
		if not request_storage_permission():
			print("Storage permission denied. Saving to tmp:// instead.")
			save_to_path(tmp_path, data)
			return

	save_to_path(user_path, data)

# Reset state by deleting the saved file in user:// or tmp://
func reset_state(path: String) -> void:
	var user_path: String = get_full_path(path, "user")
	var tmp_path: String = get_full_path(path, "tmp")

	if FileAccess.file_exists(user_path):
		DirAccess.remove_absolute(user_path)
		print("State reset by deleting ", user_path)
	elif FileAccess.file_exists(tmp_path):
		DirAccess.remove_absolute(tmp_path)
		print("State reset by deleting ", tmp_path)
	else:
		print("No state file to reset.")

# Helper function to load data from a given path
func load_from_path(full_path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var content: String = file.get_as_text()
		file.close()
		
		var json: JSON = JSON.new()
		if json.parse(content) == OK:
			print("State loaded successfully from ", full_path)
			return json.get_data()
		else:
			print("Failed to parse state file at ", full_path)
	else:
		print("Failed to open state file at ", full_path)
	
	return {}

# Helper function to save data to a given path
func save_to_path(full_path: String, data: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		print("State saved successfully to ", full_path)
	else:
		print("Failed to save state to ", full_path)

# Helper function to construct full file path with prefix
func get_full_path(path: String, prefix: String) -> String:
	if prefix_mapping.has(prefix):
		return prefix_mapping[prefix] + path
	else:
		print("Invalid prefix: ", prefix)
		return path

# Request storage permission for Android
func request_storage_permission() -> bool:
	if OS.request_permissions():
		print("Storage permission granted.")
		return true
	else:
		print("Storage permission denied.")
		return false
