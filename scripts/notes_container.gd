extends Sprite2D

@onready var ending_point: Node2D = $".."
var starting_position_x: float
var size: Vector2 = texture.get_size()
var game: Game

signal level_ready

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = get_tree().get_root().get_node("Game")
	level_ready.connect(game.on_level_ready)
	starting_position_x = size.x / 2
	set_parent_at_ending()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_parent_at_ending() -> void:
	position.x -= size.x / 2
	emit_signal("level_ready")
