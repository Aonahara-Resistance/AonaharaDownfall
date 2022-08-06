extends Node2D
class_name Dash

signal dash_started
signal dash_ended

export(PackedScene) var ghost_scene: PackedScene = preload("res://common/dash/dash_ghost.tscn")

onready var _ghost_timer: Timer = $GhostTimer
onready var _duration_timer: Timer = $DurationTimer
onready var _cooldown_timer: Timer = $CooldownTimer
onready var _dust_trail: Particles2D = $DustTrail
onready var _dust_burst: Particles2D = $DustBurst

var _dash_sprite: Sprite
var _dash_sprite_shader: ShaderMaterial

var _entity


func start_dash(entity) -> void:
	if entity.has_method("listen_to_dash"):
		_entity = entity
		if _can_dash():
			_setup_dash()
			_apply_dash_speed()
			_start_timers()
			emit_signal("dash_started")
			GameSignal.emit_signal("dash_started")
		else:
			print("cannot dash")
	else:
		print("Can't implement dash into this class, requirements are not satisfied")


func _apply_dash_speed() -> void:
	_entity.set_attribute("stamina", _entity.get_attribute("stamina") - 1)
	_entity.set_attribute(
		"acceleration", _entity.get_attribute("acceleration") + _entity.dash_speed
	)
	_entity.set_attribute("max_speed", _entity.get_attribute("max_speed") + _entity.dash_speed)


func _restore_dash_speed() -> void:
	_entity.set_attribute(
		"acceleration", _entity.get_attribute("acceleration") - _entity.dash_speed
	)
	_entity.set_attribute("max_speed", _entity.get_attribute("max_speed") - _entity.dash_speed)


func _setup_dash() -> void:
	_duration_timer.set_wait_time(_entity.dash_duration)
	_cooldown_timer.set_wait_time(_entity.dash_cooldown)
	_dash_sprite = _entity.sprite
	_dash_sprite_shader = _dash_sprite.material


func _can_dash() -> bool:
	if _entity.get_attribute("stamina") <= 0:
		Hud.show_info("You skipped leg day")
		return false
	if !_cooldown_timer.is_stopped():
		Hud.show_info("Knees weak")
		return false
	return true


func _start_timers():
	_cooldown_timer.start()
	_duration_timer.start()
	_ghost_timer.start()


func _create_trails(direction: Vector2):
	_dust_burst.set_rotation((direction * -1).angle())
	_dust_trail.restart()
	_dust_trail.set_emitting(true)
	_dust_burst.restart()
	_dust_burst.set_emitting(true)


func _instance_ghost() -> void:
	var ghost: Sprite = ghost_scene.instance()
	var ghost_target
	if get_tree().get_current_scene().get_class() == "Level":
		var current_level = get_tree().get_current_scene() as Level
		ghost_target = current_level.ysort
	else:
		ghost_target = get_tree().get_current_scene()

	ghost_target.add_child(ghost)
	ghost.global_position = global_position
	ghost.texture = _dash_sprite.texture
	ghost.vframes = _dash_sprite.vframes
	ghost.hframes = _dash_sprite.hframes
	ghost.frame = _dash_sprite.frame
	ghost.flip_h = _dash_sprite.flip_h


func _end_dash() -> void:
	_restore_dash_speed()
	_dash_sprite_shader.set_shader_param("whiten", false)
	_ghost_timer.stop()
	emit_signal("dash_ended")


func _on_DurationTimer_timeout() -> void:
	_end_dash()


func _on_GhostTimer_timeout() -> void:
	_instance_ghost()
