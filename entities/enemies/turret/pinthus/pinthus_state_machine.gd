extends StateMachine

onready var animation_tree: AnimationTree = parent.get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

func _ready() -> void:
  _add_state("idle")
  _add_state("aiming")
  _add_state("shoot")
  _add_state("die")
  set_state(states.idle)
  parent.connect("died", self, "_on_host_died")

func _state_logic(delta) -> void:
  if state != states.idle:
    animation_tree.set("parameters/idle/blend_position", parent.direction_to_target().x)
    animation_tree.set("parameters/shoot/blend_position", parent.direction_to_target().x)
    animation_tree.set("parameters/die/blend_position", parent.direction_to_target().x)
  parent.listen_knockback(delta)
  if state == states.idle:
    parent.scan_target()
    pass
  if state == states.shoot:
    parent.scan_range()
    pass
  if state == states.aiming:
    parent.scan_range()
    pass

func _enter_state(_previous_state: int, new_state: int) -> void:
  ._enter_state(_previous_state, new_state)
  match new_state:
    states.idle:
      animation_mode.travel("idle")
    states.aiming:
      animation_mode.travel("idle")
    states.shoot:
      parent.attack_timer.start()
    states.die:
      animation_mode.travel("die")
      yield(get_tree().create_timer(0.6),"timeout")
      parent.spawn_death_effect()

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


func _on_Pinthus_target_disengaged():
  print("huh")
  match state:
    states.shoot:
      parent.attack_timer.stop()
      set_state(states.idle)
    states.aiming:
      parent.attack_timer.stop()
      set_state(states.idle)

func _on_Pinthus_target_in_range():
  match state:
    states.aiming:
      set_state(states.shoot)
    
func _on_Alertsignal_alerted():
  match state:
    states.idle:
      set_state(states.aiming)

func _on_AttackTimer_timeout():
  animation_mode.travel("shoot")
