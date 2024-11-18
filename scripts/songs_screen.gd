extends Node2D

# Constants
const SONGS_FOLDER: String = "res://songs"  # Folder containing .song.json files
const NUM_COLUMNS: int = 3  # Number of columns in the grid

# Function definitions with static typing
func _ready() -> void:
	# Populate the grid with songs from the songs folder
	populate_grid()

func populate_grid() -> void:
	var scroll_container: ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer
	scroll_container.anchor_left = 0
	scroll_container.anchor_top = 0
	scroll_container.anchor_right = 1
	scroll_container.anchor_bottom = 1
	scroll_container.offset_left = 0
	scroll_container.offset_top = 0
	scroll_container.offset_right = 0
	scroll_container.offset_bottom = 0
	
	var grid: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer
	var dir: DirAccess = DirAccess.open(SONGS_FOLDER)
	
	grid.columns = 3  # Ensure three columns are used
	grid.size_flags_vertical = Control.SizeFlags.SIZE_EXPAND_FILL
	grid.size_flags_horizontal = Control.SizeFlags.SIZE_EXPAND_FILL
	
	# Check if the folder is valid
	if dir == null:
		print("Failed to open songs folder.")
		return

	# Get all files in the folder
	var files: PackedStringArray = dir.get_files()
	for file_name in files:
		if file_name.ends_with(".song.json"):  # Look for .song.json files
			var file_path: String = SONGS_FOLDER + "/" + file_name
			var json_data: Dictionary = load_json(file_path)
			if json_data:
				var image_file: String = SONGS_FOLDER + "/" + json_data.get("imageFileName", "")
				var title: String = json_data.get("displayName", "Untitled")
				var item: VBoxContainer = create_item(title, load(image_file))
				grid.add_child(item)

func load_json(file_path: String) -> Dictionary:
	# Load and parse the JSON file
	var file: FileAccess = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
	if file == null:
		print("JSON file does not exist:", file_path)
		return {}

	var json_data: String = file.get_as_text()
	file.close()

	# Parse the JSON string into a Dictionary
	var parse_result: Dictionary = JSON.parse_string(json_data)
	if parse_result != null:
		return parse_result
	else:
		print("Error parsing JSON file:", file_path, "Error:", parse_result.error_string)
		return {}


func create_item(title: String, texture: Texture2D) -> VBoxContainer:
	var item: VBoxContainer = VBoxContainer.new()
	item.size_flags_horizontal = Control.SizeFlags.SIZE_FILL
	item.alignment = BoxContainer.ALIGNMENT_CENTER

	# Add a frame
	var frame: Panel = Panel.new()
	var frame_style: StyleBoxFlat = StyleBoxFlat.new()
	frame_style.border_width_left = 2
	frame_style.border_width_top = 2
	frame_style.border_width_right = 2
	frame_style.border_width_bottom = 2
	frame_style.border_color = Color(0.8, 0.8, 0.8)
	frame.add_theme_stylebox_override("panel", frame_style)
	frame.custom_minimum_size = Vector2(300, 300)  # Set minimum size for the frame
	item.add_child(frame)

	# Add a TextureRect for the image
	var image: TextureRect = TextureRect.new()
	image.anchor_left = 0
	image.anchor_top = 0
	image.anchor_right = 1
	image.anchor_bottom = 1
	image.texture = texture
	image.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	#image.stretch_mode = TextureRect.StretchMode.STRETCH_SCALE
	#image.size_flags_horizontal = Control.SizeFlags.SIZE_SHRINK_CENTER
	#image.size_flags_vertical = Control.SizeFlags.SIZE_SHRINK_CENTER
	#image.clip_contents = true  # Ensure content does not overflow
	frame.add_child(image)

	# Add a label
	var label: Label = Label.new()
	label.text = title
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item.add_child(label)

	return item

func _on_item_pressed() -> void:
	print("Item pressed")
