extends KinematicBody2D

export var projectile: PackedScene
var velocity: Vector2
var speed: int = 120
var hp: int = 5000
onready var hpbar = $CanvasLayer/hpbar
export var indicator_damage: PackedScene = preload("res://ui/damage_indicator/damage_indicator.tscn")


func _process(_delta):
	hpbar.set_value(hp)


func shoot():
	var projectile_direction = self.global_position.direction_to(
		Party.current_character().global_position
	)
	throw_projectile(projectile_direction)
	projectile_direction = (
		self.global_position.direction_to(Party.current_character().global_position)
		+ Vector2(0, 1)
	)
	throw_projectile(projectile_direction)
	projectile_direction = (
		self.global_position.direction_to(Party.current_character().global_position)
		+ Vector2(0, -1)
	)
	throw_projectile(projectile_direction)


func move():
	if !Party.is_party_empty():
		velocity = global_position.direction_to(Party.current_character().global_position) * speed
		velocity = move_and_slide(velocity)


func melee():
	pass


func _die_check(hhp):
	if hhp <= 0:
		queue_free()


func _take_damage(damage: int) -> void:
	hp = hp - damage
	_die_check(hp)


func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position) -> PackedScene:
	var effect = EFFECT.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = effect_position
	return effect


func spawn_damage_indicator(damage: int) -> void:
	var indicator = spawn_effect(indicator_damage)
	if indicator:
		indicator.label.text = str(damage)


func _on_Hurtbox_area_entered(hitbox) -> void:
	if hitbox is WeaponHitbox:
		Shake.shake(1.0, 0.2, 1)
		_take_damage(hitbox.total_damage())
		spawn_damage_indicator(hitbox.total_damage())


func throw_projectile(projectile_direction: Vector2):
	if projectile:
		var _projectile = projectile.instance()
		get_tree().current_scene.add_child(_projectile)
		_projectile.global_position = self.global_position

		var projectile_rotation = projectile_direction.angle()
		_projectile.rotation = projectile_rotation
