extends Control

@onready var confetti_animation: AnimatedSprite2D = $ConfettiAnimation
var characters_data: Array = []
var settings_window: Node
var play_button: Button  # Declare the Play Button as a class member
var title: Label
var subtitle: Label
var new_mode_character: Dictionary = {}

func _ready() -> void:
	$MarginContainer.set_global_position(Vector2(610, 110))
	
	load_characters()
	populate_texts()
	populate_hbox()
	update_play_button_state()

func load_characters() -> void:
	var json_data: String = JourneyManager.load_characters()
	characters_data = JSON.parse_string(json_data)
	
	if JourneyManager.current_level.get("type") == "character-selection":
		for character_data: Dictionary in characters_data:
			if character_data.get("id", "") == JourneyManager.current_level.get("id", ""):
				new_mode_character = character_data
				new_mode_character["state"] = "unlocked"
				break


func populate_texts() -> void:

	# Title Label at the top center with a 20px margin
	title = Label.new()
	title.text = "נגנו מול " + JourneyManager.current_level.get("name", "")
	title.set("theme_override_font_sizes/font_size", 36)
	title.set("theme_override_colors/font_color", Color("#FFFFFF"))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.custom_minimum_size = Vector2(300, 0)
	title.position = Vector2(-170, -90)  # 20px margin from the top
	$MarginContainer.add_child(title)

	# Subtitle Label at the top center with a 60px margin
	subtitle = Label.new()
	subtitle.text = "בחרו עם מי תרצו לנגן"
	subtitle.set("theme_override_font_sizes/font_size", 24)
	subtitle.set("theme_override_colors/font_color", Color("#FFFFFF"))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.custom_minimum_size = Vector2(0, 0)
	subtitle.position = Vector2(-135, -30)  # 20px margin from the top
	$MarginContainer.add_child(subtitle)

	# Add a Spacer
	var spacer: Control = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	$MarginContainer.add_child(spacer)

	# Add an HBoxContainer for the characters
	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.name = "HBoxContainer"
	$MarginContainer.add_child(hbox)

	# Add a Spacer before the button
	var spacer_bottom: Control = Control.new()
	spacer_bottom.custom_minimum_size = Vector2(0, 30)
	$MarginContainer.add_child(spacer_bottom)

	# Add the Play Button at the bottom center with a 20px margin
	# Create the Play Button
	play_button = Button.new()
	play_button.text = "שחקו"
	play_button.set("theme_override_colors/font_color", Color("#FFFFFF"))
	play_button.add_theme_font_size_override("font_size", 24)
	play_button.custom_minimum_size = Vector2(200, 60)
	play_button.connect("pressed", Callable(self, "_on_play_pressed"))
	
	# Load the button background image
	var button_texture: Texture = load("res://art/16_dec/button.png")

	# Create a StyleBoxTexture for the normal state
	var normal_style: StyleBoxTexture = StyleBoxTexture.new()
	normal_style.texture = button_texture
	normal_style.draw_center = true  # Ensure the center is drawn

	# Apply the same style for all button states
	play_button.add_theme_stylebox_override("normal", normal_style)
	play_button.add_theme_stylebox_override("hover", normal_style)
	play_button.add_theme_stylebox_override("pressed", normal_style)
	play_button.add_theme_stylebox_override("focus", normal_style)
	play_button.add_theme_stylebox_override("disabled", normal_style)

	play_button.anchor_left = 0.5
	play_button.anchor_right = 0.5
	play_button.anchor_bottom = 1.0
	play_button.pivot_offset = Vector2(play_button.custom_minimum_size.x / 2, 0)
	play_button.position = Vector2(-120, 600)  # 20px margin from the bottom
	
	$MarginContainer.add_child(play_button)

func _on_play_pressed() -> void:
	
	for character_data: Dictionary in characters_data:
		if character_data["state"] == "selected":
			if new_mode_character:
				character_data["state"] = "unlocked"
			else:
				apply_character_params(character_data)
			
	if new_mode_character:
		new_mode_character["state"] = "unlocked"
		JourneyManager.mark_current_level_as_complete()
		NodeHelper.move_to_scene(self, "res://scenes/journey_screen.tscn")
	else:
		JourneyManager.launch_current_level(self)

	StateManager.save_state(JourneyManager.get_characters_file_path(), characters_data)

# Dedicated function to apply character parameters to the Game
func apply_character_params(character_data: Dictionary) -> void:
	var in_game_params: Dictionary = character_data.get("in-game-params", {})
	Game.player_model = "%s_%s" % [character_data.get("gender", ""), character_data.get("id", "").trim_prefix("character://")]
	Game.player_name = character_data.get("name", "")
	Game.character_attack_modifier = in_game_params.get("attack_modifier", 1.0)
	Game.character_health_modifier = in_game_params.get("health_modifier", 1.0)
	Game.strong_attacks = in_game_params.get("strong_attacks", false)
	Game.bigger_health = in_game_params.get("bigger_health", false)

	print("Player Model:", Game.player_model)
	print("Player Name:", Game.player_name)
	print("Attack Modifier:", Game.character_attack_modifier)
	print("Health Modifier:", Game.character_health_modifier)
	print("Strong Attacks:", Game.strong_attacks)
	print("Bigger Health:", Game.bigger_health)
	
	
func populate_hbox() -> void:
	var hbox: HBoxContainer = $MarginContainer/ScrollContainer/HBoxContainer
	
	# Remove all existing children to refresh the view
	for child in hbox.get_children():
		hbox.remove_child(child)
		child.queue_free()  # Free the child node to prevent memory leaks

	# If a character with mode == "new" exists, render only that one
	if new_mode_character:
		hbox.add_child(create_item({}))
		var item: Control = create_item(new_mode_character)
		hbox.add_child(item)
		title.text = "קבלו את " + new_mode_character.get("name") + "!"
		title.offset_top += 40
		subtitle.text = ""
		play_button.text = "המשיכו"
		play_button.disabled = false
		$UnlockBackground.visible = true
		play_confetti_animation()
	else:
		# Render all characters if no "new" character is found
		for character_data: Dictionary in characters_data:
			var item: Control = create_item(character_data)
			hbox.add_child(item)
					

func play_confetti_animation() -> void:
	confetti_animation.visible = true
	confetti_animation.play("end_screen_confetti")
	
func create_item(character_data: Dictionary) -> Control:
	# Determine image based on state
	var state: String = character_data.get("state", "")
	var images: Dictionary = character_data.get("images", {})
	var image_file: String = images.get("locked", "") if state == "locked" else images.get("unlocked", "")

	# Extract the name
	var name: String = character_data.get("name", "")

	# Extract parameters
	var parameters: Dictionary = character_data.get("parameters", {})
	var attack: int = parameters.get("attack", 0)
	var defense: int = parameters.get("defense", 0)
	var speed: int = parameters.get("speed", 0)

	# Create a Control node as the root item
	var item: Control = Control.new()
	item.custom_minimum_size = Vector2(300, 600)

	# If the item is locked, set opacity and disable interaction
	if state == "locked":
		item.modulate = Color(1, 1, 1, 0.8)  # Set opacity to 0.8
		item.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Make the item unclickable
	else:
		item.mouse_filter = Control.MOUSE_FILTER_STOP  # Allow interaction for non-locked items

	# Create a Panel as the frame (transparent background with yellow border)
	var frame: Panel = Panel.new()
	frame.custom_minimum_size = Vector2(293, 525)
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var frame_style: StyleBoxFlat = StyleBoxFlat.new()
	frame_style.bg_color = Color(0, 0, 0, 0)  # Transparent background
	frame_style.border_color = Color(0, 0, 0, 0)  # Transparent border by default
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
	background_image.position = Vector2(-8, -4)
	background_image.custom_minimum_size = Vector2(400, 732)
	background_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	background_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	frame.add_child(background_image)

	# Add a TextureRect for the character image
	var character_image: TextureRect = TextureRect.new()
	character_image.texture = load(image_file)
	character_image.custom_minimum_size = Vector2(200, 200)
	character_image.scale = Vector2(0.9, 0.9)
	character_image.position = Vector2(55, 18)
	character_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	character_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(character_image)
	item.add_child(frame)

	# Add a label for the character name
	var label: Label = Label.new()
	label.text = name
	label.set("theme_override_colors/font_color", Color("#FFD44F"))
	label.set("theme_override_font_sizes/font_size", 24)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.custom_minimum_size = Vector2(300, 50)
	label.position = Vector2(-34, 320)
	item.add_child(label)

	# Add a state icon in the top-right corner
	var state_icon: TextureRect = TextureRect.new()
	state_icon.custom_minimum_size = Vector2(50, 50)
	state_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	match state:
		"selected":
			state_icon.texture = load("res://art/16_dec/selected.png")
			state_icon.position = Vector2(215, 10)
		"locked":
			state_icon.texture = load("res://art/16_dec/lock.png")
			state_icon.position = Vector2(210, 10)
		"unlocked":
			pass
		"new":
			pass
		_:
			state_icon.texture = null
			item.modulate = Color(1,1,1,0)

	item.add_child(state_icon)

	# Create a VBoxContainer for the parameters
	var parameters_vbox: VBoxContainer = VBoxContainer.new()
	parameters_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	parameters_vbox.position = Vector2(27, 396)
	parameters_vbox.scale = Vector2(0.75, 0.75)
	parameters_vbox.add_theme_constant_override("separation", 15)

	# Add the attack icons
	var attack_hbox: HBoxContainer = create_parameter_hbox("res://art/16_dec/attack.png", attack)
	parameters_vbox.add_child(attack_hbox)

	# Add the defense icons
	var defense_hbox: HBoxContainer = create_parameter_hbox("res://art/16_dec/defense.png", defense)
	parameters_vbox.add_child(defense_hbox)

	# Add the speed icons
	var speed_hbox: HBoxContainer = create_parameter_hbox("res://art/16_dec/speed.png", speed)
	parameters_vbox.add_child(speed_hbox)

	# Add the parameters VBoxContainer to the item
	item.add_child(parameters_vbox)

	# Connect the input event for non-locked items
	if state == "unlocked":
		var connected: bool = item.connect("gui_input", Callable(self, "_on_item_selected").bind(character_data))
		print("Connection successful:", connected)

	return item

func create_parameter_hbox(texture_path: String, count: int) -> HBoxContainer:
	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	hbox.layout_direction = Control.LAYOUT_DIRECTION_RTL
	hbox.add_theme_constant_override("separation", 5)  # 5 pixels between icons

	for i in range(5):
		var icon: TextureRect = TextureRect.new()
		if i < count:
			icon.texture = load(texture_path)  # Use the provided texture for filled icons
		else:
			icon.texture = load("res://art/16_dec/parameter.png")  # Default texture for empty slots
		icon.custom_minimum_size = Vector2(9, 16)
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hbox.add_child(icon)

	return hbox


func update_play_button_state() -> void:
	# Enable the play button if any character is selected
	var is_selected: bool = characters_data.any(func(char: Dictionary) -> bool: return char.get("state") == "selected")
	if not new_mode_character.is_empty():
		play_button.disabled = false
	elif is_selected:
		play_button.disabled = false	
	else:
		play_button.disabled = true

	# Set opacity based on the disabled state
	play_button.modulate = Color(1, 1, 1, 0.4) if play_button.disabled else Color(1, 1, 1, 1)


func _on_item_selected(event: InputEvent, character_data: Dictionary) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Update the state of characters
		for char: Dictionary in characters_data:
			if char["id"] == character_data["id"]:
				char["state"] = "selected"
			elif char["state"] == "selected":
				char["state"] = "unlocked"

		# Refresh the view
		populate_hbox()
		update_play_button_state()


func _on_back_button_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/journey_screen.tscn")
