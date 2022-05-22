extends Node2D
class_name Dash

signal dash_ended

export(float) var dash_delay: float = 1.5

onready var duration_timer: Timer = $DurationTimer
onready var ghost_timer: Timer = $GhostTimer
onready var cooldown_timer: Timer = $CooldownTimer
onready var dust_trail: Particles2D = $DustTrail
onready var dust_burst: Particles2D = $DustBurst
onready var character: Character = get_parent()

var ghost_scene: PackedScene = preload("res://common/dash/dash_ghost.tscn")
var can_dash: bool setget set_can_dash, get_can_dash
var dash_sprite: Sprite
var dash_sprite_shader: ShaderMaterial


# * Just in case we ~~need~~ want to change the dash delay
func _ready() -> void:
	cooldown_timer.wait_time = dash_delay


func set_can_dash(new_value: bool) -> void:
	can_dash = new_value


func get_can_dash() -> bool:
	if character.get_attribute("stamina") <= 0:
		return false
	else:
		return true


func cooldown_finished() -> bool:
	return cooldown_timer.is_stopped()


func start_dash(character_sprite: Sprite, duration: float, direction: Vector2) -> void:
	Hud.update_hud()
	Shake.shake(1, 0.1)
	set_can_dash(false)

	character.hurtbox.disabled = true

	cooldown_timer.start()
	duration_timer.wait_time = duration
	duration_timer.start()

	dash_sprite = character_sprite
	dash_sprite_shader = dash_sprite.material
	dash_sprite_shader.set_shader_param("mix_weight", 0.7)
	dash_sprite_shader.set_shader_param("whiten", true)

	ghost_timer.start()
	instance_ghost()

	dust_trail.restart()
	dust_trail.emitting = true

	dust_burst.rotation = (direction * -1).angle()
	dust_burst.restart()
	dust_burst.emitting = true


func instance_ghost() -> void:
	var ghost: Sprite = ghost_scene.instance()

	# ? Will hopefully get the character node :koronesweat:
	get_node("../..").add_child(ghost)

	ghost.global_position = global_position
	ghost.texture = dash_sprite.texture
	ghost.vframes = dash_sprite.vframes
	ghost.hframes = dash_sprite.hframes
	ghost.frame = dash_sprite.frame
	ghost.flip_h = dash_sprite.flip_h


func is_dashing() -> bool:
	return !duration_timer.is_stopped()


func end_dash() -> void:
	emit_signal("dash_ended")

	character.hurtbox.disabled = false

	dash_sprite_shader.set_shader_param("whiten", false)
	ghost_timer.stop()


func _on_DurationTimer_timeout() -> void:
	end_dash()


func _on_GhostTimer_timeout() -> void:
	instance_ghost()


func _on_CooldownTimer_timeout() -> void:
	set_can_dash(true)


func get_cooldown_timer() -> float:
	return cooldown_timer.time_left
