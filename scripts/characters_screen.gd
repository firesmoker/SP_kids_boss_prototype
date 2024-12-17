extends Control

const CHARACTERS_FILE_PATH: String = "res://characters/characters.json"

var characters_data: Array = []
var settings_window: Node

func _ready() -> void:
	$MarginContainer.set_global_position(Vector2(600, 100))
	load_characters()
	populate_hbox()

func load_characters() -> void:
	var file: FileAccess = FileAccess.open(CHARACTERS_FILE_PATH, FileAccess.READ)
	if file:
		var json_data: String = file.get_as_text()
		file.close()
		characters_data = JSON.parse_string(json_data)
	else:
		print("Failed to open file at path:", CHARACTERS_FILE_PATH)

func populate_hbox() -> void:
	var hbox: HBoxContainer = $MarginContainer/ScrollContainer/HBoxContainer

	for character_data: Dictionary in characters_data:
		var item: Control = create_item(character_data)
		
		# Create a MarginContainer for spacing
		var container: MarginContainer = MarginContainer.new()
		container.add_theme_constant_override("margin_left", 0)
		container.add_theme_constant_override("margin_top", 0)
		container.add_theme_constant_override("margin_right", 0)
		container.add_theme_constant_override("margin_bottom", 0)
		container.add_child(item)
		
		hbox.add_child(container)

func create_item(character_data: Dictionary) -> Control:
	# Determine image based on state
	var state: String = character_data.get("state", "locked")
	var images: Dictionary = character_data.get("images", {})
	var image_file: String = images.get("unlocked") if state != "locked" else images.get("locked")

	# Extract the name
	var name: String = character_data.get("name", "")

	# Create a Control node as the root item
	var item: Control = Control.new()
	item.custom_minimum_size = Vector2(300, 532)

	# Create a Panel as the frame (transparent background with yellow border)
	var frame: Panel = Panel.new()
	frame.custom_minimum_size = Vector2(293, 525)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var frame_style: StyleBoxFlat = StyleBoxFlat.new()
	frame_style.bg_color = Color(0, 0, 0, 0)  # Transparent background
	frame_style.border_color = Color(0, 0, 0, 0)  # Transparent background
	frame_style.border_width_top = 5
	frame_style.border_width_bottom = 5
	frame_style.border_width_left = 5
	frame_style.border_width_right = 5
	frame_style.set_corner_radius_all(24)

	# Show border only if the state is "selected"
	if state == "selected":
		frame_style.border_color = Color("#FFD44F")  # Yellow border

	frame.add_theme_stylebox_override("panel", frame_style)

	# Add a TextureRect for the background image
	var background_image: TextureRect = TextureRect.new()
	background_image.texture = load("res://art/16_dec/character-item.png")
	background_image.scale = Vector2(0.7, 0.7)
	background_image.position.x -= 8
	background_image.position.y -= 4
	background_image.custom_minimum_size = Vector2(400, 732)
	background_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Add the background image to the frame
	frame.add_child(background_image)

	# Add a TextureRect for the character image
	var character_image: TextureRect = TextureRect.new()
	character_image.texture = load(image_file)
	character_image.custom_minimum_size = Vector2(200, 200)
	character_image.scale = Vector2(0.9, 0.9)
	character_image.position = Vector2(55, 18)
	character_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Add the character image to the frame (on top of the background image)
	frame.add_child(character_image)

	# Add the frame to the item
	item.add_child(frame)

	# Add a label for the character name
	var label: Label = Label.new()
	label.text = name
	label.set("theme_override_colors/font_color", Color("#FFD44F"))  # Set text color to yellow
	label.set("font_size", 24)  # Set text color to yellow
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.custom_minimum_size = Vector2(300, 532)
	label.position = Vector2(-30, 80)  # Position it at the top-right corner
	item.add_child(label)

	# Add a state icon in the top-right corner
	var state_icon: TextureRect = TextureRect.new()
	state_icon.custom_minimum_size = Vector2(50, 50)
	state_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	match state:
		"selected":
			state_icon.texture = load("res://art/16_dec/selected.png")
			state_icon.position = Vector2(215, 10)  # Position it at the top-right corner
		"locked":
			state_icon.texture = load("res://art/16_dec/lock.png")
			state_icon.position = Vector2(210, 10)  # Position it at the top-right corner
		_:
			state_icon.texture = null  # No icon for unlocked state

	item.add_child(state_icon)

	return item

func _on_settings_pressed() -> void:
	print("Settings pressed")
	if not settings_window:
		settings_window = load("res://scenes/settings_screen.tscn").instantiate()
		get_tree().root.add_child(settings_window)
	else:
		settings_window.visible = !settings_window.visible

func _on_songs_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")
