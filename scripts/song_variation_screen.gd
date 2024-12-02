extends Control

var model: Dictionary
@onready var container: HBoxContainer = $HBoxContainer
@onready var header_label: Label = $HeaderLabel

static var shuffled: bool = false
static var button_order: Array = []  # Stores the shuffled indices

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
	NodeHelper.move_to_scene(self, "res://scenes/song_difficulty_screen.tscn", Callable(self, "on_song_difficulty_screen_created"))


func _on_continue_button_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")

func on_song_difficulty_screen_created(song_difficulty_screen: SongDifficultyScreen) -> void:
	song_difficulty_screen.model = model

func _ready() -> void:
	# Shuffle buttons if not already shuffled
	if not shuffled:
		shuffle_buttons()
	apply_saved_order()
	header_label.text = model.get("displayName")
	
func shuffle_buttons() -> void:
	print("Shuffling buttons for the first time")
	var children: Array[Node] = container.get_children()

	button_order = range(children.size())
	button_order.shuffle()

	shuffled = true

func apply_saved_order() -> void:
	if button_order.is_empty():
		print("Button order is empty. Skipping reordering.")
		return

	var children: Array[Node] = container.get_children()
	if children.size() != button_order.size():
		print("Mismatch between children count and button order size.")
		return

	# Create a new array to store the reordered children
	var reordered_children: Array = []
	for index: int in button_order:
		if index < 0 or index >= children.size():
			print("Invalid index in button_order: ", index)
			return
		reordered_children.append(children[index])

	# Clear and re-add children in the new order
	for child in children:
		container.remove_child(child)
	for child: Node in reordered_children:
		container.add_child(child)

func _on_back_button_pressed() -> void:
	NodeHelper.move_to_scene(self, "res://scenes/songs_screen.tscn")
