extends StateMachine

onready var animation_tree: AnimationTree = parent.get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")

var noise: OpenSimplexNoise

var isSkillActive: bool = false

var staff_shake: float


func _ready() -> void:
  _add_state("idle")
  _add_state("move")
  _add_state("casting")
  _add_state("after_cast")
  _add_state("dash")
  set_state(states.idle)

  parent.get_node("Skills").get_child(1).connect("skill_activated", self, "_on_bdsm_activated")
  parent.get_node("Skills").get_child(1).connect("skill_canceled", self, "_on_bdsm_canceled")
  parent.get_node("Skills").get_child(1).connect("skill_casted", self, "_on_bdsm_casted")


func _on_bdsm_activated():
  isSkillActive = true


func _on_bdsm_canceled():
  isSkillActive = false


func _on_bdsm_casted():
  isSkillActive = false
  set_state(states.casting)


func _unhandled_input(event):
  if parent.is_in_control:
    if state == states.idle:
      if !isSkillActive:
        parent.listen_to_skills(event)
        parent.listen_to_attacks(event)
      parent.listen_to_party_change(event)
      parent.listen_to_input_direction(event)
      parent.sprite_control()
      parent.listen_to_dash(event)

    if state == states.move:
      if !isSkillActive:
        parent.listen_to_skills(event)
        parent.listen_to_attacks(event)
      parent.listen_to_party_change(event)
      parent.listen_to_input_direction(event)
      parent.sprite_control()
      parent.listen_to_dash(event)

    if state == states.casting:
      pass

    if state == states.after_cast:
      pass

    if state == states.dash:
      if !isSkillActive:
        parent.listen_to_skills(event)
        parent.listen_to_attacks(event)
      parent.listen_to_party_change(event)
      parent.listen_to_input_direction(event)
      parent.sprite_control()

func shake_staff(shake_intensity) -> void:
  staff_shake = shake_intensity
  parent.weapon.position = Vector2(randf(), randf()) * shake_intensity

func stop_shaking() -> void:
  var new_shake = lerp(staff_shake, 0, 0.1)
  staff_shake = new_shake


func _state_logic(delta) -> void:
  animation_tree.set("parameters/idle/blend_position", parent.get_mouse_direction().x)
  animation_tree.set("parameters/walk/blend_position", parent.get_mouse_direction().x)

  if !state == states.casting && !state == states.after_cast:
    parent.move(delta)
  if state == states.casting:
    shake_staff(1.5)
  if state == states.after_cast:
    shake_staff(5)
  if state == states.idle:
    if floor(staff_shake) > 0:
      stop_shaking()
      shake_staff(staff_shake)
  if state == states.move:
    if floor(staff_shake) > 0:
      stop_shaking()
      shake_staff(staff_shake)


func _enter_state(_previous_state: int, new_state: int) -> void:
  ._enter_state(_previous_state, new_state)
  match new_state:
    states.idle:
      animation_mode.travel("idle")
    states.move:
      animation_mode.travel("walk")
    states.casting:
      animation_mode.travel("casting")
    states.after_cast:
      animation_mode.travel("after_cast")


func _get_transition() -> int:
  match state:
    states.idle:
      if parent.velocity.length() > 10:
        return states.move
      if !parent.skill_two.cast_timer.is_stopped():
        return states.casting
    states.move:
      if parent.velocity.length() < 10:
        return states.idle
      if round(parent.velocity.length()) > parent.get_attribute("max_speed"):
        return states.dash
      if !parent.skill_two.cast_timer.is_stopped():
        return states.casting
    states.dash:
      if true:
        return states.move
    states.casting:
      if parent.skill_two.cast_timer.is_stopped():
        return states.after_cast
    states.after_cast:
      if str(animation_mode.get_current_node()) == "idle":
        return states.idle

  return -1
