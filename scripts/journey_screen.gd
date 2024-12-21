extends Control

var levels_data: Array = []
var settings_window: Node
@onready var scroll_container: ScrollContainer = $MarginContainer/ScrollContainer

func _ready() -> void:
	$MarginContainer.set_global_position(Vector2(600, 100))
	load_levels()
	populate_hbox()
	
	# Defer restoring the scroll position to ensure the UI is ready
	await get_tree().process_frame
	restore_scroll_position()

func load_levels() -> void:
	var json_data: String = JourneyManager.load_levels()
	levels_data = JSON.parse_string(json_data)
func create_item(level_data: Dictionary, state: String) -> Control:
	# Determine image based on state
	var images: Dictionary = level_data.get("images", {})
	var image_file: String = images.get(state) if images.has(state) else ""

	# Fallback to "unlocked" if no specific state image is found
	image_file = image_file if image_file != "" else images.get("unlocked")

	# Extract the text
	var text: String = level_data.get("text", "")

	# Create a VBoxContainer for the overall layout
	var item: VBoxContainer = VBoxContainer.new()
	item.alignment = BoxContainer.ALIGNMENT_CENTER
	item.custom_minimum_size = Vector2(240, 290)

	# Create a Panel as the frame (transparent background with yellow border) wrapping only the image
	var frame: Panel = Panel.new()
	frame.custom_minimum_size = Vector2(240, 240)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var frame_style: StyleBoxFlat = StyleBoxFlat.new()
	frame_style.bg_color = Color(0, 0, 0, 0)  # Transparent background
	frame_style.border_color = Color("#FFD44F")  # Yellow border
	frame_style.border_width_top = 5
	frame_style.border_width_bottom = 5
	frame_style.border_width_left = 5
	frame_style.border_width_right = 5
	frame_style.set_corner_radius_all(24)
	frame.add_theme_stylebox_override("panel", frame_style)

	# Add a TextureRect for the main image inside the frame with margins to adjust positioning
	var image: TextureRect = TextureRect.new()
	image.texture = load(image_file)
	image.custom_minimum_size = Vector2(200, 200)  # Image size fits within the frame
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Add margins to move the image 10px left and up within the frame
	var image_margin: MarginContainer = MarginContainer.new()
	image_margin.add_theme_constant_override("margin_left", 10)
	image_margin.add_theme_constant_override("margin_top", 10)
	image_margin.add_child(image)

	# Add the image with margin adjustments to the frame
	frame.add_child(image_margin)

	# Add the frame to the item
	item.add_child(frame)

	# Add a margin of 20 between the frame and the text
	var spacer: Control = Control.new()
	spacer.custom_minimum_size = Vector2(0, 0)
	item.add_child(spacer)

	# Add the main text label
	var label: Label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item.add_child(label)

	# Add a MarginContainer for the status icon with a right margin of 20
	var status_icon_container: MarginContainer = MarginContainer.new()
	status_icon_container.add_theme_constant_override("margin_right", 40)
	status_icon_container.add_theme_constant_override("margin_top", 10)

	var status_icon: TextureRect = TextureRect.new()
	status_icon.custom_minimum_size = Vector2(50, 50)
	status_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	if state == "complete":
		status_icon.texture = load("res://art/16_dec/checkmark.png")
		status_icon_container.position = Vector2(160, 0)
	elif state == "locked":
		status_icon.texture = load("res://art/16_dec/lock.png")
		status_icon_container.position = Vector2(160, 0)

	# Add the status icon to the MarginContainer
	status_icon_container.add_child(status_icon)

	frame.add_child(status_icon_container)

	return item

func populate_hbox() -> void:
	var hbox: HBoxContainer = $MarginContainer/ScrollContainer/HBoxContainer

	# Clear existing children
	for child in hbox.get_children():
		hbox.remove_child(child)
		child.queue_free()

	# Filter levels_data to only include items with "in-game-params"
	var in_game_levels_data: Array = levels_data.filter(func(level_data: Dictionary) -> bool:
		return level_data.has("in-game-params")
	)

	var found_first_uncomplete: bool = false

	for i: int in range(in_game_levels_data.size()):
		var level_data: Dictionary = in_game_levels_data[i]

		# Determine the state
		var state: String = "locked"
		if level_data.get("is_complete", false):
			state = "complete"
		elif not found_first_uncomplete:
			state = "unlocked"
			found_first_uncomplete = true
		else:
			state = "locked"

		var item: Control = create_item(level_data, state)

		# Check opacity conditions
		var frame: Panel = item.get_child(0) as Panel  # Assuming the frame is the first child
		if state == "complete" or state == "unlocked":
			set_item_opacity(frame, 1.0)
			item.connect("gui_input", Callable(self, "_on_item_clicked").bind(level_data.get("in-game-params", {})))
		else:
			set_item_opacity(frame, 0.8)

		# Create a MarginContainer for spacing
		var container: MarginContainer = MarginContainer.new()
		container.add_theme_constant_override("margin_left", -5)
		container.add_theme_constant_override("margin_top", 15)
		container.add_theme_constant_override("margin_right", -5)
		container.add_theme_constant_override("margin_bottom", 15)
		container.add_child(item)

		hbox.add_child(container)

		# Add a horizontal yellow line between items, except after the last item
		if i < in_game_levels_data.size() - 1:
			var separator: Control = create_horizontal_line()
			hbox.add_child(separator)

func _on_item_clicked(event: InputEvent, in_game_params: Dictionary) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		JourneyManager.set_current_level(in_game_params)
		save_scroll_position()
		NodeHelper.move_to_scene(self, "res://scenes/characters_screen.tscn")


func set_item_opacity(frame: Panel, opacity: float) -> void:
	# Apply opacity to the children of the frame, not the frame itself
	for child in frame.get_children():
		child.modulate.a = opacity

func create_horizontal_line() -> Control:
	# Create a container for the line
	var line_container: Control = Control.new()
	line_container.custom_minimum_size = Vector2(130, 5)  # Base width of 130, height of 5
	line_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	line_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Create a Panel to act as the horizontal line
	var line: Panel = Panel.new()
	line.custom_minimum_size = Vector2(130, 5)  # Stretch to 130px total width

	var line_style: StyleBoxFlat = StyleBoxFlat.new()
	line_style.bg_color = Color("#FFD44F")  # Yellow color
	line.add_theme_stylebox_override("panel", line_style)

	# Apply a transform to move the line 20 pixels up
	line.position.y -= 20

	# Add the line to the container
	line_container.add_child(line)

	return line_container

func _on_settings_pressed() -> void:
	print("Settings pressed")
	if not settings_window:
		settings_window = load("res://scenes/settings_screen.tscn").instantiate()
		get_tree().root.add_child(settings_window)
	else:
		settings_window.visible = !settings_window.visible
	
	load_levels()
	populate_hbox()

func _on_songs_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")


# Save the current scroll position
func save_scroll_position() -> void:
	var scroll_position: Vector2 = Vector2(scroll_container.scroll_horizontal, scroll_container.scroll_vertical)
	JourneyManager.save_scroll_position(scroll_position.x)

# Restore the scroll position
func restore_scroll_position() -> void:
	var scroll_position: int = JourneyManager.load_scroll_position()
	scroll_container.scroll_horizontal = scroll_position
