extends StateMachine

onready var animation_tree: AnimationTree = parent.get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

func _ready() -> void:
  _add_state("idle")
  _add_state("shoot")
  _add_state("die")
  set_state(states.idle)
  parent.connect("died", self, "_on_host_died")

func _state_logic(delta) -> void:
  animation_tree.set("parameters/idle/blend_position", parent.direction_to_target().x)
  animation_tree.set("parameters/walk/blend_position", parent.direction_to_target().x)
  animation_tree.set("parameters/explode/blend_position", parent.direction_to_target().x)
  animation_tree.set("parameters/die/blend_position", parent.direction_to_target().x)
  parent.listen_knockback(delta)
  if state == states.idle:
    # look for target
    pass
  if state == states.shoot:
    # shoot at target
    pass
  if state == states.die:
    # do dying  stuff
    pass

func _enter_state(_previous_state: int, new_state: int) -> void:
  ._enter_state(_previous_state, new_state)
  match new_state:
    states.idle:
      animation_mode.travel("idle")
    states.shoot:
      animation_mode.travel("shoot")
    states.die:
      animation_mode.travel("die")

func _get_transition() -> int:
  match state:
    states.idle:
      pass
    states.shoot:
      pass
    states.die:
      pass
  return -1

func _on_host_died():
  set_state(states.die)
