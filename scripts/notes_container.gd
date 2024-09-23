extends Sprite2D

@onready var ending_point: Node2D = $".."
var starting_position_x: float
var size: Vector2 = texture.get_size()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position_x = size.x / 2
	set_parent_at_ending()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_parent_at_ending() -> void:
	position.x -= size.x / 2
