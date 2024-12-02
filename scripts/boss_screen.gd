extends Control

const NUM_COLUMNS: int = 4
const BOSSES_FILE_PATH: String = "res://boss/boss.json"

var bosses_data: Array = []
var settings_window: Node

func _ready() -> void:
	$MarginContainer.set_global_position(Vector2(600, 100))
	load_bosses()
	populate_grid()

func load_bosses() -> void:
	var file: FileAccess = FileAccess.open(BOSSES_FILE_PATH, FileAccess.ModeFlags.READ)
	if file:
		var json_data: String = file.get_as_text()
		file.close()

		bosses_data = JSON.parse_string(json_data)
	else:
		print("Failed to open file at path:", BOSSES_FILE_PATH)

func populate_grid() -> void:
	var grid: GridContainer = $MarginContainer/ScrollContainer/GridContainer
	grid.columns = NUM_COLUMNS

	for boss_data: Dictionary in bosses_data:
		var item: Panel = create_item(boss_data)
		
		# Create a MarginContainer
		var container: MarginContainer = MarginContainer.new()
		container.add_theme_constant_override("margin_left", 5)
		container.add_theme_constant_override("margin_top", 5)
		container.add_theme_constant_override("margin_right", 5)
		container.add_theme_constant_override("margin_bottom", 5)
		container.add_child(item)
		
		grid.add_child(container)

func create_item(boss_data: Dictionary) -> Control:
	# Extract data from boss_data
	var image_file: String = boss_data.get("image", "")
	var title: String = boss_data.get("displayName", "")
	var artist: String = boss_data.get("artist", "")

	# Add a frame
	var frame: Panel = Panel.new()
	frame.offset_top = 12
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var frame_style: StyleBoxFlat = StyleBoxFlat.new()
	frame_style.bg_color = Color("#2c649e")
	frame_style.set_corner_radius_all(8)
	frame_style.border_color = Color(1, 1, 1, 0)
	frame.add_theme_stylebox_override("panel", frame_style)
	frame.custom_minimum_size = Vector2(270, 390)  # Set minimum size for the frame
	
	# Create a VBoxContainer for layout
	var item: VBoxContainer = VBoxContainer.new()
	item.offset_top = 12
	item.offset_left = -16
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.size_flags_horizontal = Control.SizeFlags.SIZE_FILL
	item.alignment = BoxContainer.ALIGNMENT_CENTER
	frame.add_child(item)

	# Add a TextureRect for the image
	var image: TextureRect = BossTextureRect.new()
	image.model = boss_data
	image.mouse_filter = Control.MOUSE_FILTER_PASS
	image.texture = load(image_file)
	image.custom_minimum_size = Vector2(300, 300)
	image.size_flags_horizontal = Control.SIZE_FILL
	image.size_flags_vertical = Control.SIZE_FILL
	image.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	item.add_child(image)

	# Add padding label
	var padding_label: Label = Label.new()
	padding_label.add_theme_font_size_override("font_size", 6)
	item.add_child(padding_label)

	# Add a boss name label
	var label: Label = Label.new()
	label.pivot_offset = Vector2(0, 100)
	label.text = title
	label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_ARBITRARY
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item.add_child(label)

	# Add an artist label
	var artist_label: Label = Label.new()
	artist_label.add_theme_font_size_override("font_size", 14)
	artist_label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	var font_variation: FontVariation = FontVariation.new()
	font_variation.variation_embolden = -0.5
	artist_label.add_theme_font_override("font", font_variation)
	artist_label.text = artist
	artist_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item.add_child(artist_label)

	return frame


func _on_settings_pressed() -> void:
	print("Settings pressed")
	if not settings_window:
		settings_window = load("res://scenes/settings_screen.tscn").instantiate()
		get_tree().root.add_child(settings_window)
	else:
		settings_window.visible = !settings_window.visible


func _on_songs_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")
