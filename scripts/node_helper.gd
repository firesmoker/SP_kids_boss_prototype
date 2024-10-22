class_name NodeHelper

static func get_ancestor_game(current_node: Node) -> Game:
	while current_node != null:
		current_node = current_node.get_parent()  # Move up to the parent
		if current_node is Game:  # Check if the parent is of type `Game`
			return current_node as Game  # Return the ancestor if it's of type `Game`
	return null  # Return null if no `Game` ancestor is found
