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
