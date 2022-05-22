extends StateMachine

onready var animation_tree: AnimationTree = parent.get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")


func _ready() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("explode")
	_add_state("die")
	set_state(states.idle)


func _state_logic(delta) -> void:
	animation_tree.set("parameters/idle/blend_position", parent.direction_to_target().x)
	animation_tree.set("parameters/walk/blend_position", parent.direction_to_target().x)
	animation_tree.set("parameters/explode/blend_position", parent.direction_to_target().x)
	animation_tree.set("parameters/die/blend_position", parent.direction_to_target().x)

	parent.listen_knockback(delta)

	if state == states.move:
		print(parent.velocity)
		parent.move(delta)

	# if state == states.die:


func _enter_state(_previous_state: int, new_state: int) -> void:
	._enter_state(_previous_state, new_state)
	match new_state:
		states.idle:
			animation_mode.travel("idle")
		states.move:
			animation_mode.travel("walk")
		states.explode:
			animation_mode.travel("explode")
		states.die:
			animation_mode.travel("die")


func _get_transition() -> int:
	match state:
		states.idle:
			if !Party.is_party_empty():
				if (
					parent.global_position.distance_to(Party.current_character().global_position)
					< 500
				):
					return states.move
				if (
					parent.global_position.distance_to(Party.current_character().global_position)
					< 20
				):
					return states.explode
			if parent.get_attribute("hp") <= 0:
				return states.die
		states.move:
			if !Party.is_party_empty():
				if (
					parent.global_position.distance_to(Party.current_character().global_position)
					< 20
				):
					return states.explode
				if (
					parent.global_position.distance_to(Party.current_character().global_position)
					> 500
				):
					return states.idle
			if parent.get_attribute("hp") <= 0:
				return states.die

	return -1
