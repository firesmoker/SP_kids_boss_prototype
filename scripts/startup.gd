# startup.gd
extends Node

func _ready() -> void:
	print("App has started!")
	StateManager.reset_all_data()
