extends StateMachine

onready var animation: AnimationPlayer = parent.get_node("AnimationPlayer")
onready var animation_tree: AnimationTree = parent.get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")


func _ready() -> void:
	_add_state("idle")
	_add_state("shoot")
	_add_state("die")
	set_state(states.idle)


func _state_logic(delta) -> void:
	animation_tree.set("parameters/idle/blend_position", parent.direction_to_target().x)
	animation_tree.set("parameters/shoot/blend_position", parent.direction_to_target().x)
	animation_tree.set("parameters/die/blend_position", parent.direction_to_target().x)

	parent.listen_knockback(delta)

	if state == states.shoot:
		if parent.attack_timer.is_stopped():
			animation_mode.travel("shoot")


func _enter_state(_previous_state: int, new_state: int) -> void:
	._enter_state(_previous_state, new_state)
	match new_state:
		states.idle:
			animation_mode.travel("idle")
		states.shoot:
			if parent.attack_timer.is_stopped():
				animation_mode.travel("shoot")
		states.die:
			animation_mode.travel("die")


func _get_transition() -> int:
	match state:
		states.idle:
			if !Party.is_party_empty():
				if (
					(
						parent.global_position.distance_to(
							Party.current_character().global_position
						)
						< 100
					)
					&& parent.attack_timer.is_stopped()
				):
					return states.shoot
			if parent.get_attribute("hp") <= 0:
				return states.die
	match state:
		states.shoot:
			if !Party.is_party_empty():
				if (
					parent.global_position.distance_to(Party.current_character().global_position)
					> 100
				):
					return states.idle
			if parent.get_attribute("hp") <= 0:
				return states.die

	return -1
