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
onready var whiskers: Node2D = $Whiskers

var velocity: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var target setget set_target, get_target

export var hp: int
export var max_hp: int
export var max_speed: int
export var base_damage: int
export var acceleration: int
export var agro_radius: int
export var receives_knockback: bool
export var steering_force: float
export var avoid_force: float

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
	attributes = EnemeyAttributes.new(
		hp,
		max_hp,
		max_speed,
		base_damage,
		acceleration,
		steering_force,
		avoid_force,
		receives_knockback
	)
	enemy_hitbox.damage = get_attribute("base_damage")
	modifier_tick()


## -----------------------------------------------------------------------------
##																Movement Stuff
## -----------------------------------------------------------------------------


func move():
	var steering: Vector2 = Vector2.ZERO
	steering += seek_steering()
	steering = steering.clamped(steering_force)
	steering += avoid_obstacles_steering()
	velocity += steering

	velocity = move_and_slide(velocity)


func direction_to_target():
	return global_position.direction_to(get_target().global_position)


# Wander around designated radius
func patrol() -> void:
	pass


# Seek target
func seek_steering() -> Vector2:
	var desired_velocity: Vector2 = (
		direction_to_target().normalized()
		* get_attribute("acceleration")
	)
	return desired_velocity - velocity


# Slowly slows down on arrival at destination
func arrival_steering() -> void:
	pass


# Avoid obstacles while maintaining course to target
func avoid_obstacles_steering() -> Vector2:
	whiskers.rotation = velocity.angle()
	for whisker in whiskers.get_children():
		whisker.cast_to.x = velocity.length()
		if whisker.is_colliding():
			var obstacle = whisker.get_collider()
			return (position + velocity - obstacle.position).normalized() * avoid_force
	return Vector2.ZERO


## -----------------------------------------------------------------------------
##																Combat Stuff
## -----------------------------------------------------------------------------


func get_target():
	if !Party.is_party_empty():
		return Party.current_character()
	return self


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


func shoot_projectile() -> void:
	var active_projectile = projectile.instance()
	get_tree().current_scene.add_child(active_projectile)
	active_projectile.direction = direction_to_target()
	active_projectile.global_position = self.global_position
	active_projectile.launch()
	pass


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
		"agro_radius": res.agro_radius,
		"receives_knockback": res.receives_knockback,
	}

## -----------------------------------------------------------------------------
##																Misc
## -----------------------------------------------------------------------------
