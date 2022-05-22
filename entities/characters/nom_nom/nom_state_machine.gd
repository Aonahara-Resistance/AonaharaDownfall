extends StateMachine

onready var animation = parent.get_node("AnimationPlayer")


func _ready() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("dash")
	set_state(states.idle)


func _state_logic(delta) -> void:
	print(parent.velocity)
	parent.move(delta)
	parent.apply_dash()
	parent.sprite_control()
	parent.listen_knockback(delta)

	if state != states.idle:
		parent.listen_to_dash()


func _unhandled_input(event):
	if parent.is_in_control:
		if state == states.idle:
			parent.listen_to_skills(event)
			parent.listen_to_attacks(event)
			parent.listen_to_party_change(event)
			parent.listen_to_input_direction(event)
			parent.sprite_control()

		if state == states.move:
			parent.listen_to_skills(event)
			parent.listen_to_attacks(event)
			parent.listen_to_party_change(event)
			parent.listen_to_input_direction(event)
			parent.sprite_control()

		if state == states.dash:
			parent.listen_to_skills(event)
			parent.listen_to_attacks(event)
			parent.listen_to_party_change(event)
			parent.listen_to_input_direction(event)
			parent.sprite_control()


func _enter_state(_previous_state: int, new_state: int) -> void:
	._enter_state(_previous_state, new_state)
	match new_state:
		states.idle:
			animation.play("idle")
		states.move:
			animation.play("move")


func _get_transition() -> int:
	match state:
		states.idle:
			if parent.velocity.length() > 10:
				return states.move
		states.move:
			if parent.velocity.length() < 10:
				return states.idle
			if round(parent.velocity.length()) > parent.get_attribute("max_speed"):
				return states.dash
		states.dash:
			if parent.dash.is_dashing() != true:
				return states.move

	return -1
