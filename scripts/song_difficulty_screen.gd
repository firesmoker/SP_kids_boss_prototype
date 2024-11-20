extends Control

@onready var header_label: Label = $HeaderLabel
var model: Dictionary

func _ready() -> void:
	header_label.text = model.get("displayName")

func _on_EasyButton_pressed() -> void:
	print("Easy mode selected!")
	move_to_core_game()

func _on_MediumButton_pressed() -> void:
	print("Medium mode selected!")
	move_to_core_game()

func _on_HardButton_pressed() -> void:
	print("Hard mode selected!")
	move_to_core_game()

func move_to_core_game() -> void:	
	var new_screen: Node = load("res://scenes/game.tscn").instantiate()
	new_screen.model = model
	get_tree().root.add_child(new_screen)
