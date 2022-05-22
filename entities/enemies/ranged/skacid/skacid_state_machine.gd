extends StateMachine

onready var animation: AnimationPlayer = parent.get_node("AnimationPlayer")
onready var animation_tree: AnimationTree = parent.get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")


func _ready() -> void:
	_add_state("fly")
	_add_state("shoot")
	_add_state("die")
	set_state(states.fly)


func _state_logic(delta) -> void:
	parent.listen_knockback(delta)

	if state == states.fly:
		parent.move(delta)


func _enter_state(_previous_state: int, new_state: int) -> void:
	._enter_state(_previous_state, new_state)
	match new_state:
		states.fly:
			animation.play("fly")
		states.shoot:
			animation.play("shoot")
		states.die:
			animation.play("die")


func _get_transition() -> int:
	match state:
		states.fly:
			if !Party.is_party_empty():
				if (
					parent.global_position.distance_to(Party.current_character().global_position)
					> 50
				):
					return states.shoot
			if parent.get_attribute("hp") <= 0:
				return states.die
	match state:
		states.shoot:
			if !Party.is_party_empty():
				if (
					parent.global_position.distance_to(Party.current_character().global_position)
					< 50
				):
					return states.fly
			if parent.get_attribute("hp") <= 0:
				return states.die

	return -1
