extends TextureRect
class_name SongTextureRect

func _ready() -> void:
	# Create a ShaderMaterial
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	
	# Create and assign a shader to the ShaderMaterial
	shader_material.shader = Shader.new()
	shader_material.shader.code = """
		shader_type canvas_item;

		// Uniform to control the corner radius
		uniform float radius = 0.1;

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
	
func _gui_input(event: InputEvent) -> void:
	
	if event is InputEventScreenTouch and not event.is_pressed():
		print("Song clicked!")
