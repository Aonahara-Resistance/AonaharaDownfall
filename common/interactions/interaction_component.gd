extends Area2D
class_name InteractionComponent

export var interaction_parent: NodePath
var interaction_target

signal on_interactable_changed(newInteractable)


func _process(_delta) -> void:
	if interaction_target != null && Input.is_action_just_pressed("interact"):
		if interaction_target.has_method("interaction_interact"):
			interaction_target.interaction_interact(self)


func _on_InteractionComponent_body_entered(body) -> void:
	body = body.interaction
	var can_interact: bool = false
	if body.has_method("interaction_can_interact"):
		can_interact = body.interaction_can_interact(get_node(interaction_parent))

	if !can_interact:
		return

	if body.has_method("show_ui"):
		body.show_ui()

	interaction_target = body
	emit_signal("on_interactable_changed", interaction_target)


func _on_InteractionComponent_body_exited(body) -> void:
	body = body.interaction
	if body.has_method("hide_ui"):
		body.hide_ui()
	if body == interaction_target:
		interaction_target = null
		emit_signal("on_interactable_changed", null)
