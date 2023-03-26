extends Node
class_name InteractableItem

var character
var ui_component
export var ui_component_path: NodePath

func _ready() -> void:
	ui_component = get_node(ui_component_path)

# By default interactable items are only availble to the Character class
func interaction_can_interact(interactionComponentParent: Node) -> bool:
	character = interactionComponentParent
	return interactionComponentParent is Character

func show_ui() -> void:
	ui_component.set_visible(true)

func hide_ui() -> void:
	ui_component.set_visible(false)
