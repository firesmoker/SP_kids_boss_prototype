extends Control

var model: Dictionary
@onready var container: HBoxContainer = $HBoxContainer
@onready var header_label: Label = $HeaderLabel
static var shuffled_once: bool = false

func _on_SP_pressed() -> void:
	print("SP mode selected!")
	Game.sp_mode = true
	move_to_difficulty_screen()

func _on_Boss_pressed() -> void:
	print("Boss mode selected!")
	move_to_difficulty_screen()

func _on_Library_pressed() -> void:
	print("Library mode selected!")
	Game.sp_mode = false
	move_to_difficulty_screen()

func move_to_difficulty_screen() -> void:	
	var new_screen: Node = load("res://scenes/song_difficulty_screen.tscn").instantiate()
	new_screen.model = model
	get_tree().root.add_child(new_screen)

func _ready() -> void:
	#if not shuffled_once:
		#shuffle_buttons()
	header_label.text = model.get("displayName")
	

func shuffle_buttons() -> void:
	# Get all children (buttons) as a list
	print("shuffling buttons, shuffled_once is: " + str(shuffled_once))
	var children: Array[Node] = container.get_children()

	# Convert to an array and shuffle it
	children.shuffle()
	

	# Rearrange the children in the shuffled order
	for i in range(children.size()):
		container.move_child(children[i], i)
		
		
func _on_back_button_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")
		
