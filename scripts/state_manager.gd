extends Node

class_name StateManager

# Mapping of prefixes to their corresponding paths
const PREFIX_MAPPING: Dictionary = {
	"res": "res://",
	"user": "user://",
	"tmp": "tmp://"
}

# Load state as a string, prioritizing tmp://, then user://, and falling back to res://
static func load_state(path: String) -> String:
	var tmp_path: String = get_full_path(path, "tmp")
	var user_path: String = get_full_path(path, "user")
	var res_path: String = get_full_path(path, "res")

	# Try to load from tmp:// first
	if FileAccess.file_exists(tmp_path):
		return load_from_path(tmp_path)

	# Try to load from user://
	if FileAccess.file_exists(user_path):
		return load_from_path(user_path)

	# Fallback to res://
	if FileAccess.file_exists(res_path):
		return load_from_path(res_path)

	print("State file not found in tmp://, user://, or res://")
	return ""

# Save (update) state to tmp:// or user:// based on permissions
static func save_state(path: String, data: String) -> void:
	var tmp_path: String = get_full_path(path, "tmp")
	var user_path: String = get_full_path(path, "user")

	# On mobile, request permissions before saving to user://
	if OS.has_feature("Android"):
		if not request_storage_permission():
			print("Storage permission denied. Saving to tmp:// instead.")
			save_to_path(tmp_path, data)
			return

	save_to_path(user_path, data)

# Reset state by deleting the saved file in tmp:// or user://
static func reset_state(path: String) -> void:
	var tmp_path: String = get_full_path(path, "tmp")
	var user_path: String = get_full_path(path, "user")

	if FileAccess.file_exists(tmp_path):
		DirAccess.remove_absolute(tmp_path)
		print("State reset by deleting ", tmp_path)
	elif FileAccess.file_exists(user_path):
		DirAccess.remove_absolute(user_path)
		print("State reset by deleting ", user_path)
	else:
		print("No state file to reset.")

# Helper function to load data from a given path and return as a string
static func load_from_path(full_path: String) -> String:
	var file: FileAccess = FileAccess.open(full_path, FileAccess.READ)
	if file:
		var content: String = file.get_as_text()
		file.close()
		print("State loaded successfully from ", full_path)
		return content
	else:
		print("Failed to open state file at ", full_path)
	
	return ""

static func save_to_path(full_path: String, data: String) -> void:
	# Ensure the parent directory exists
	var dir_path: String = full_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		var dir: DirAccess = DirAccess.open("user://")
		var error: Error = dir.make_dir_recursive(dir_path)
		if error != OK:
			print("Failed to create directory: ", dir_path)
			return

	# Open the file in WRITE mode (creates the file if it doesn't exist)
	var file: FileAccess = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_string(data)
		file.close()
		print("State saved successfully to ", full_path)
	else:
		print("Failed to save state to ", full_path)


# Helper function to construct full file path with prefix
static func get_full_path(path: String, prefix: String) -> String:
	if PREFIX_MAPPING.has(prefix):
		return PREFIX_MAPPING[prefix] + path
	else:
		print("Invalid prefix: ", prefix)
		return path

# Request storage permission for Android
static func request_storage_permission() -> bool:
	if OS.request_permissions():
		print("Storage permission granted.")
		return true
	else:
		print("Storage permission denied.")
		return false
