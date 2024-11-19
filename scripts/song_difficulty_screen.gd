extends Control
@onready var container: HBoxContainer = $HBoxContainer

func _on_SP_pressed() -> void:
	print("SP mode selected!")

func _on_Boss_pressed() -> void:
	print("Boss mode selected!")

func _on_Library_pressed() -> void:
	print("Library mode selected!")

func _ready() -> void:
	shuffle_buttons()

func shuffle_buttons() -> void:
	# Get all children (buttons) as a list
	var children: Array[Node] = container.get_children()
	
	# Convert to an array and shuffle it
	children.shuffle()

	# Rearrange the children in the shuffled order
	for i in range(children.size()):
		move_child(children[i], i)
