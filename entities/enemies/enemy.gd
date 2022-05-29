extends KinematicBody2D
class_name Enemy

var attributes
export var effect_hit: PackedScene = preload("res://common/effects/hit_effect.tscn")
export var effect_died: PackedScene = preload("res://common/effects/death_effect.tscn")
export var indicator_damage: PackedScene = preload("res://ui/damage_indicator/damage_indicator.tscn")
export var projectile: PackedScene = preload("res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard.tscn")

onready var ai = $Ai
onready var animation: AnimationPlayer = $AnimationPlayer
onready var modifiers: Node2D = $Modifiers
onready var enemy_hitbox: Hitbox = $Hitbox
onready var alert_signal = $Alertsignal
onready var attack_timer: Timer = $AttackTimer
onready var player_detector: Node2D = $PlayerDetector
onready var range_detector: RayCast2D = $RangeDetector
onready var wall_detector: RayCast2D = $WallDetector
onready var whiskers: Node2D = $Whiskers
onready var patrol_cooldown_timer: Timer = $PatrolCooldown
onready var state_machine = $StateMachine

signal patrol_finished
signal target_disengaged
signal target_in_range
var velocity: Vector2 = Vector2.ZERO
var choosen_direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var spawn_group: String = ""
var is_pouncing: bool = false setget set_is_pouncing
var target = self setget set_target, get_target
var reverse_scan: int = 1
var spawn_location: Vector2

export var hp: int
export var max_hp: int
export var max_speed: int
export var base_damage: int
export var acceleration: int
export var receives_knockback: bool
export var avoid_force: float = 1000

export var arrival_radius: int = 50
export var patrol_range: int = 200
export var patrol_cooldown: int = 2
export var sight_range: int = 100
export var attack_radius: int = 20
export var disengage_radius: int = 500

var active_attributes: Dictionary = {
	"hp": 0,
	"max_hp": 0,
	"max_speed": 0,
	"base_damage": 0,
	"acceleration": 0,
	"agro_radius": 0,
	"receives_knockback": true,
}

## -----------------------------------------------------------------------------
##																Virtual Methods
## -----------------------------------------------------------------------------


func _ready():
	spawn_location = global_position
	attributes = EnemeyAttributes.new(
		hp, max_hp, max_speed, base_damage, acceleration, avoid_force, receives_knockback
	)
	enemy_hitbox.damage = get_attribute("base_damage")
	for detector in player_detector.get_children():
		detector.cast_to.x = sight_range
	patrol_cooldown_timer.wait_time = patrol_cooldown
	range_detector.cast_to.x = attack_radius

	var __ = Party.connect("active_party_switched", self, "_on_party_changed")

	modifier_tick()


## -----------------------------------------------------------------------------
##																Movement Stuff
## -----------------------------------------------------------------------------


func chase(delta):
	var steering: Vector2 = Vector2.ZERO
	steering += seek_steering() * 60 * delta
	steering += avoid_obstacles_steering() * 60 * delta
	steering = steering.clamped(get_attribute("acceleration"))
	velocity += steering * 60 * delta
	velocity = velocity.clamped(get_attribute("max_speed"))
	velocity = move_and_slide(velocity)
	range_detector.rotation = velocity.angle()
	if (target.global_position - global_position).length() > disengage_radius:
		emit_signal("target_disengaged")
	if range_detector.is_colliding():
		emit_signal("target_in_range")


func retreat(delta):
	print(spawn_location)
	var steering: Vector2 = Vector2.ZERO
	steering += arrival_steering() * 60 * delta
	steering += avoid_obstacles_steering() * 60 * delta
	steering = steering.clamped(get_attribute("acceleration"))
	velocity += steering * 60 * delta
	velocity = velocity.clamped(get_attribute("max_speed"))
	velocity = move_and_slide(velocity)
	if global_position.floor() == target.global_position.floor():
		emit_signal("patrol_finished")


func set_retreat_target() -> Dictionary:
	return {"global_position": spawn_location}


func generate_patrol_target() -> Dictionary:
	randomize()
	return {
		"global_position":
		Vector2(
			rand_range(patrol_range * -1, patrol_range), rand_range(patrol_range * -1, patrol_range)
		)
	}


func patrol(delta):
	var steering: Vector2 = Vector2.ZERO
	wall_detector.rotation = velocity.angle()
	steering += arrival_steering() * 60 * delta
	steering += avoid_obstacles_steering() * 60 * delta
	steering = steering.clamped(get_attribute("acceleration"))
	velocity += steering * 60 * delta
	velocity = velocity.clamped(get_attribute("max_speed"))
	velocity = move_and_slide(velocity)
	if global_position.floor() == target.global_position.floor():
		emit_signal("patrol_finished")
	if wall_detector.is_colliding():
		emit_signal("patrol_finished")


func direction_to_target():
	if get_target() is Character:
		return global_position.direction_to(get_target().hurtbox.global_position)
	else:
		return global_position.direction_to(get_target().global_position)


func seek_steering() -> Vector2:
	var desired_velocity: Vector2 = direction_to_target() * get_attribute("max_speed")
	return desired_velocity - velocity


func arrival_steering() -> Vector2:
	var speed: float = (
		((global_position - target.global_position).length() / 50)
		* get_attribute("max_speed")
	)
	var desired_velocity: Vector2 = direction_to_target() * speed
	return desired_velocity - velocity


func avoid_obstacles_steering() -> Vector2:
	whiskers.rotation = velocity.angle()
	for whisker in whiskers.get_children():
		whisker.cast_to.x = velocity.length()
		if whisker.is_colliding():
			var obstacle = whisker.get_collider()
			return (position + velocity - obstacle.position).normalized() * 1000
	return Vector2.ZERO


## -----------------------------------------------------------------------------
##																Combat Stuff
## -----------------------------------------------------------------------------


func scan_target():
	player_detector.rotation += 10
	for detector in player_detector.get_children():
		var collider = detector.get_collider()
		if collider is Character:
			if collider.is_in_control == true:
				set_target(collider)
				alert_signal.alert()


func get_target():
	return target


func set_target(new_target) -> void:
	target = new_target


func listen_knockback(delta) -> void:
	if get_attribute("receives_knockback"):
		knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
		knockback = move_and_slide(knockback)


func apply_knockback(direction, strength) -> void:
	knockback = (direction.direction_to(self.global_position) * strength)


func _on_Hurtbox_area_entered(hitbox) -> void:
	if hitbox is WeaponHitbox:
		var final_damage = _randomize_damage(hitbox.total_damage())
		apply_knockback(hitbox.global_position, hitbox.knockback_strength)
		Shake.shake(1.0, 0.2, 1)
		spawn_hit_effect()
		_take_damage(final_damage)
		spawn_damage_indicator(final_damage)


func _randomize_damage(damage: int) -> int:
	return int(round(rand_range(damage * 0.9, damage * 1.2)))


func _take_damage(damage: int) -> void:
	set_attribute("hp", get_attribute("hp") - damage)


func _die() -> void:
	# Do dying stuff before freeing
	queue_free()


func remove_from_spawn_group():
	if spawn_group != "":
		remove_from_group(spawn_group)


func shoot_projectile() -> void:
	var active_projectile = projectile.instance()
	get_tree().current_scene.add_child(active_projectile)
	active_projectile.direction = direction_to_target()
	active_projectile.global_position = self.global_position
	active_projectile.launch_at_player()
	attack_timer.start()


func set_is_pouncing(value):
	if value == false:
		attack_timer.start()
	is_pouncing = value


func pounce(delta) -> void:
	if is_pouncing:
		velocity = move_and_slide(velocity)
		velocity += 10 * direction_to_target() * delta * 60
		velocity = lerp(velocity, Vector2.ZERO, get_attribute("friction"))


## -----------------------------------------------------------------------------
##																Sprites
## -----------------------------------------------------------------------------


func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position) -> PackedScene:
	var effect = EFFECT.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = effect_position
	return effect


func spawn_death_effect() -> void:
	var _hit_effect = spawn_effect(effect_died)


func spawn_hit_effect() -> void:
	var _hit_effect = spawn_effect(effect_hit)


func spawn_damage_indicator(damage: int) -> void:
	var indicator = spawn_effect(indicator_damage)
	if indicator:
		indicator.label.text = str(damage)


## -----------------------------------------------------------------------------
##																Modifier Stuff
## -----------------------------------------------------------------------------


func get_attribute(attribute: String):
	if active_attributes.has(attribute):
		modifier_tick()
		return active_attributes[attribute]
	else:
		print("Attribute does not exist")
		return 0


func set_attribute(attribute: String, new_value):
	if attributes.stateful_attributes.has(attribute):
		attributes.stateful_attributes[attribute] = new_value
	else:
		attributes.stateless_attributes[attribute] = new_value
	modifier_tick()
	Hud.update_hud()


func apply_modifier(new_modifier: Modifier) -> void:
	modifiers.add_child(new_modifier)
	modifier_tick()
	new_modifier.modify_stateful(self)


func get_modifiers() -> Array:
	return modifiers.get_children()


func modifier_tick() -> void:
	var res: Dictionary = attributes.stateless_attributes.duplicate()
	var modifier_list: Array = get_modifiers()
	for modifier in modifier_list:
		res = modifier.modify_stateless(res)
	active_attributes = {
		"hp": attributes.stateful_attributes.hp,
		"max_hp": res.max_hp,
		"max_speed": res.max_speed,
		"base_damage": res.base_damage,
		"acceleration": res.acceleration,
		"receives_knockback": res.receives_knockback,
	}


## -----------------------------------------------------------------------------
##																Misc
## -----------------------------------------------------------------------------


func _on_party_changed(character):
	if target is Character && target != character:
		target = character
