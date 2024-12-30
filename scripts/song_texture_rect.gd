extends TextureRect
class_name SongTextureRect

var model: Dictionary
	
func _ready() -> void:
	# Create a ShaderMaterial
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	# Create and assign a shader to the ShaderMaterial
	shader_material.shader = Shader.new()
	shader_material.shader.code = """
		shader_type canvas_item;

		// Uniform to control the corner radius
		uniform float radius = 0.05;

		void fragment() {
			// Normalized UV position
			vec2 uv = UV * 2.0 - 1.0; // Scale UV to range [-1, 1]

			// Calculate rounded corner mask
			float corner = length(max(abs(uv) - vec2(1.0 - radius), 0.0));
			if (corner > radius) {
				discard; // Discard pixels outside rounded corners
			}

			// Output the texture color
			COLOR = texture(TEXTURE, UV);
		}
	"""
	
	# Assign the material to the TextureRect
	self.material = shader_material  # Assigning the ShaderMaterial to this TextureRect

var pressed_event_position: Vector2

func move_to_difficulty_screen() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/song_difficulty_screen.tscn", Callable(self, "on_song_difficulty_screen_created"))

func on_song_difficulty_screen_created(song_difficulty_screen: SongDifficultyScreen) -> void:
	song_difficulty_screen.model = model

func _gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		pressed_event_position = get_global_transform().basis_xform(event.position)
		
	if event is InputEventScreenTouch and event.is_released() and not event.is_canceled():
		var  released_event_position: Vector2 = get_global_transform().basis_xform(event.position)
		if released_event_position.distance_to(pressed_event_position) < 0.1:
			print("Song clicked!")
			
			Game.sp_mode = false
			move_to_difficulty_screen()
			
			#var new_screen: Node = load("res://scenes/song_variation_screen.tscn").instantiate()
			#new_screen.model = model
			#get_tree().root.add_child(new_screen)
