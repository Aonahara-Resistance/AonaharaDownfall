extends StateMachine

onready var animation = parent.get_node("AnimationPlayer")
onready var audio = parent.get_node("AudioStreamPlayer2D")


func _ready() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("melee")
	_add_state("shoot")
	set_state(states.move)


func _state_logic(_delta) -> void:
	match state:
		states.idle:
			pass
		states.move:
			parent.move()
			pass
		states.melee:
			pass
		states.shoot:
			pass


func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation.play("idle")
		states.move:
			animation.play("move")
		states.melee:
			animation.play("melee")
			audio.play()
		states.shoot:
			animation.play("shoot")


func _get_transition() -> int:
	match state:
		states.idle:
			pass
		states.move:
			if parent.global_position.distance_to(Party.current_character().global_position) < 30:
				return states.melee
			if parent.global_position.distance_to(Party.current_character().global_position) > 120:
				return states.shoot
		states.melee:
			if parent.global_position.distance_to(Party.current_character().global_position) > 50:
				return states.move
			if parent.global_position.distance_to(Party.current_character().global_position) > 120:
				return states.shoot
		states.shoot:
			if parent.global_position.distance_to(Party.current_character().global_position) < 100:
				return states.move

	return -1
