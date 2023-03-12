extends Node2D
class_name Dash

signal dash_started
signal dash_ended

export(PackedScene) var ghost_scene: PackedScene = preload("res://common/dash/dash_ghost.tscn")

onready var ghost_timer: Timer = $GhostTimer
onready var duration_timer: Timer = $DurationTimer
onready var cooldown_timer: Timer = $CooldownTimer
onready var dust_trail: Particles2D = $DustTrail
onready var dust_burst: Particles2D = $DustBurst

var dash_sprite: Sprite
var dash_sprite_shader: ShaderMaterial

var entity


func start_dash(new_entity) -> void:
  if new_entity.has_method("listen_to_dash"):
    entity = new_entity
    if can_dash():
      setup_dash()
      apply_dash_speed()
      start_timers()
      emit_signal("dash_started")
      GameSignal.emit_signal("dash_started")
  else:
    print("Can't implement dash into this class, requirements are not satisfied")


func apply_dash_speed() -> void:
  entity.set_attribute("stamina", entity.get_attribute("stamina") - 1)
  entity.set_attribute(
    "acceleration", entity.get_attribute("acceleration") + entity.dash_speed
  )
  entity.set_attribute("max_speed", entity.get_attribute("max_speed") + entity.dash_speed)


func restore_dash_speed() -> void:
  entity.set_attribute(
    "acceleration", entity.get_attribute("acceleration") - entity.dash_speed
  )
  entity.set_attribute("max_speed", entity.get_attribute("max_speed") - entity.dash_speed)


func setup_dash() -> void:
  duration_timer.set_wait_time(entity.dash_duration)
  cooldown_timer.set_wait_time(entity.dash_cooldown)
  dash_sprite = entity.sprite
  dash_sprite_shader = dash_sprite.material


func can_dash() -> bool:
  # TODO: Refactor into signals
  if entity.get_attribute("stamina") <= 0:
    UiUtils.show_info("You skipped leg day")
    return false
  if !cooldown_timer.is_stopped():
    UiUtils.show_info("Knees weak")
    return false
  return true


func start_timers():
  cooldown_timer.start()
  duration_timer.start()
  ghost_timer.start()


func create_trails(direction: Vector2):
  dust_burst.set_rotation((direction * -1).angle())
  dust_trail.restart()
  dust_trail.set_emitting(true)
  dust_burst.restart()
  dust_burst.set_emitting(true)


func instance_ghost() -> void:
  var ghost: Sprite = ghost_scene.instance()
  var ghost_target = get_ghost_target()

  ghost_target.add_child(ghost)
  ghost.global_position = global_position
  ghost.texture = dash_sprite.texture
  ghost.vframes = dash_sprite.vframes
  ghost.hframes = dash_sprite.hframes
  ghost.frame = dash_sprite.frame
  ghost.flip_h = dash_sprite.flip_h


func get_ghost_target():
  if get_tree().get_current_scene().get_class() == "Level":
    var current_level = get_tree().get_current_scene() as Level
    return current_level.ysort
  else:
    return get_tree().get_current_scene()


func end_dash() -> void:
  restore_dash_speed()
  dash_sprite_shader.set_shader_param("whiten", false)
  ghost_timer.stop()
  emit_signal("dash_ended")


func _on_DurationTimer_timeout() -> void:
  end_dash()


func _on_GhostTimer_timeout() -> void:
  instance_ghost()
