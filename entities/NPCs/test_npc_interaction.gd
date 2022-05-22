extends InteractableItem


func interaction_interact(_interactionComponentParent: Node) -> void:
	var dialog = Dialogic.start("test_interaction")
	add_child(dialog)
