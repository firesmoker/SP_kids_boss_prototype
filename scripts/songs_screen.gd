extends Control

var settings_window: Node

# Constants
const SONGS_FOLDER: String = "res://songs"  # Folder containing .song.json files
const NUM_COLUMNS: int = 4  # Number of columns in the grid

# Function definitions with static typing
func _ready() -> void:
	# Populate the grid with songs from the songs folder
	
	$MarginContainer.set_global_position(Vector2(600, 100))
	$VBoxContainer/Control/Button.connect("pressed", Callable(self, "_on_settings_pressed"))
	populate_grid()


func populate_grid() -> void:
	
	var scroll_container: ScrollContainer = $MarginContainer/ScrollContainer
	scroll_container.scroll_started.connect(Callable(self, "_on_scroll_started"))
	scroll_container.scroll_ended.connect(Callable(self, "_on_scroll_ended"))

	var grid: GridContainer = $MarginContainer/ScrollContainer/GridContainer
	
	grid.columns = NUM_COLUMNS  # Ensure three columns are used
	grid.size_flags_horizontal = 0
	grid.size_flags_vertical = 0
	var dir: DirAccess = DirAccess.open(SONGS_FOLDER)
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
				var item: Control = create_item(json_data)
				
				# Create a MarginContainer
				var container: MarginContainer = MarginContainer.new()
				container.add_theme_constant_override("margin_left", 5)
				container.add_theme_constant_override("margin_top", 5)
				container.add_theme_constant_override("margin_right", 5)
				container.add_theme_constant_override("margin_bottom", 5)
				container.add_child(item)
				
				grid.add_child(container)

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


func create_item(json_data: Dictionary) -> Control:
	
	var image_file: String = SONGS_FOLDER + "/" + json_data.get("imageFileName", "")
	var title: String = json_data.get("displayName", "")
	var artist: String = json_data.get("artist", "")
	# Add a frame
	var frame: Panel = Panel.new()
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var frame_style: StyleBoxFlat = StyleBoxFlat.new()
	frame_style.bg_color =  Color("#5D139E") 
	frame_style.set_corner_radius_all(5)
	frame_style.border_color = Color(1, 1, 1, 0)
	frame.add_theme_stylebox_override("panel", frame_style)
	frame.custom_minimum_size = Vector2(180, 260)  # Set minimum size for the frame
	
	var item: VBoxContainer = VBoxContainer.new()
	item.offset_top = 5
	item.offset_left = -10
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE

	item.size_flags_horizontal = Control.SizeFlags.SIZE_FILL
	item.alignment = BoxContainer.ALIGNMENT_CENTER
	frame.add_child(item)
	
	# Add a TextureRect for the image
	var image: TextureRect = SongTextureRect.new()
	image.model = json_data
	image.mouse_filter = Control.MOUSE_FILTER_PASS
	image.texture = load(image_file)
	image.custom_minimum_size = Vector2(200, 200)  
	image.size_flags_horizontal = Control.SIZE_FILL
	image.size_flags_vertical = Control.SIZE_FILL
	image.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	#image.stretch_mode = TextureRect.StretchMode.STRETCH_SCALE
	#image.size_flags_horizontal = Control.SizeFlags.SIZE_SHRINK_CENTER
	#image.size_flags_vertical = Control.SizeFlags.SIZE_SHRINK_CENTER
	#image.clip_contents = true  # Ensure content does not overflow
	item.add_child(image)

	# Add a Song name label
	var label: Label = Label.new()
	label.add_theme_font_size_override("font_size", 14)
	
	label.text = title
	label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_ARBITRARY
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item.add_child(label)

	# Add a Artist label
	var artist_label: Label = Label.new()
	# Apply it to the Label
	artist_label.add_theme_font_size_override("font_size", 12)
	artist_label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	var fv: FontVariation = FontVariation.new()
	#fv.base_font = load("res://BarlowCondensed-Regular.ttf")
	fv.variation_embolden = -0.5
	artist_label.add_theme_font_override("font", fv)

	artist_label.text = artist
	artist_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item.add_child(artist_label)
	
	return frame

func _on_settings_pressed() -> void:
	print("Settings pressed")
	if not settings_window:
		settings_window = load("res://scenes/start_screen.tscn").instantiate()
		get_tree().root.add_child(settings_window)
	else:
		settings_window.visible = !settings_window.visible

func _on_scroll_started() -> void:
	print("Scroll started")
	_disable_child_input()

func _on_scroll_ended() -> void:
	print("Scroll ended")
	_enable_child_input()

func _disable_child_input() -> void:
	# Recursively disable input for all Control children
	_set_child_input(self, Control.MOUSE_FILTER_IGNORE)

func _enable_child_input() -> void:
	# Recursively enable input for all Control children
	_set_child_input(self, Control.MOUSE_FILTER_PASS)

func _set_child_input(node: Node, filter: Control.MouseFilter) -> void:
	# Recursively apply the mouse filter to all Control nodes
	for child in node.get_children():
		if child is SongTextureRect:
			child.mouse_filter = filter
		_set_child_input(child, filter)
