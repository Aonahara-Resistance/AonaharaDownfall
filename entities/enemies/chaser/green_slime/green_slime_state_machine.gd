extends StateMachine

onready var animation_tree: AnimationTree = parent.get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

func _ready() -> void:
  _add_state("idle")
  _add_state("patrol")
  _add_state("chase")
  _add_state("retreat")
  _add_state("attack")
  _add_state("die")
  set_state(states.idle)
  parent.connect("died", self, "_on_host_died")

func _state_logic(delta) -> void:
  animation_tree.set("parameters/idle/blend_position", parent.direction_to_target().x)
  animation_tree.set("parameters/move/blend_position", parent.direction_to_target().x)
  animation_tree.set("parameters/attack/blend_position", parent.direction_to_target().x)
  animation_tree.set("parameters/die/blend_position", parent.direction_to_target().x)
  parent.listen_knockback(delta)
  if state == states.chase:
    parent.scan_range()
    parent.chase(delta)
  if state == states.idle:
    parent.scan_target()
  if state == states.patrol:
    parent.scan_target()
    parent.patrol(delta)
  if state == states.retreat:
    parent.scan_target()
    parent.patrol(delta)

func _enter_state(_previous_state: int, new_state: int) -> void:
  ._enter_state(_previous_state, new_state)
  match new_state:
    states.idle:
      animation_mode.travel("idle")
      parent.get_node("PatrolCooldown").start()
      parent.target = parent.generate_patrol_target()
    states.patrol:
      animation_mode.travel("move")
    states.chase:
      animation_mode.travel("move")
    states.retreat:
      parent.target = parent.generate_patrol_target()
      animation_mode.travel("move")
    states.attack:
      parent.attack_timer.start()
      animation_mode.travel("attack")
      parent.pounce()
    states.die:
      animation_mode.travel("die")

func _get_transition() -> int:
  match state:
    states.idle:
      pass
    states.patrol:
      pass
    states.chase:
      pass
    states.retreat:
      pass
    states.attack:
      pass
    states.die:
      pass
  return -1

func _on_host_died():
  set_state(states.die)

func _on_Alertsignal_alerted():
  match state:
    states.idle:
      set_state(states.chase)
    states.patrol:
      set_state(states.chase)
    states.retreat:
      set_state(states.chase)

func _on_PatrolCooldown_timeout():
  match state:
    states.idle:
      set_state(states.patrol)


func _on_GreenSlime_patrol_finished():
  match state:
    states.patrol:
      set_state(states.idle)
    states.retreat:
      set_state(states.idle)

func _on_GreenSlime_target_disengaged():
  match state:
    states.chase:
      set_state(states.retreat)

func _on_GreenSlime_target_in_range():
  match state:
    states.chase:
      if parent.attack_timer.is_stopped():
        set_state(states.attack)


func _on_GreenSlime_attack_finished():
  match state:
    states.attack:
      set_state(states.chase)

