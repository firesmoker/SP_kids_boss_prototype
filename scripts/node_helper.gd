class_name NodeHelper

static func get_ancestor_game(current_node: Node) -> Game:
	while current_node != null:
		current_node = current_node.get_parent()  # Move up to the parent
		if current_node is Game:  # Check if the parent is of type `Game`
			return current_node as Game  # Return the ancestor if it's of type `Game`
	return null  # Return null if no `Game` ancestor is found

static func get_root_game(node: Node) -> Game:
	var tree:  SceneTree = node.get_tree()
	var root: Node = tree.root  # Get the root node
	for child: Node in root.get_children():
		if child is Game:  # Check if the child is of type Game
			return child   # Return the instance if found
	return null  # Return null if no instance of Game is found

static func move_to_scene(node: Node, scene_path: String, on_scene_created: Callable = Callable()) -> Node2D:
	# Remove all current scenes
	var root: Node = node.get_tree().root
	for child in root.get_children():
		root.remove_child(child)
		child.queue_free()

	var packed_scene: Resource = load(scene_path)  # Load the PackedScene
	if packed_scene and packed_scene is PackedScene:
		var scene: Node2D = packed_scene.instantiate()
		
		# Execute the callback if provided
		if on_scene_created and on_scene_created.is_valid():
			on_scene_created.call(scene)
			
		root.add_child(scene)
		return scene  # Add the instance to the root
		
	return null
