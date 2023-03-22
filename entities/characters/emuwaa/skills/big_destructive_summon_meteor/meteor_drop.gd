extends Area2D

onready var explosion_animation: AnimationPlayer = $ExplosionHitbox/AnimationPlayer
onready var animation: AnimationPlayer = $AnimationPlayer
onready var explosion_collision: CollisionShape2D = $ExplosionHitbox/CollisionShape2D
onready var explosion_hitbox: ExplosionHitbox = $ExplosionHitbox
onready var fire_collision: CollisionShape2D = $FireHitbox/CollisionShape2D
onready var fire_hitbox: WeaponHitbox = $FireHitbox
onready var duration_timer: Timer = $Duration
onready var fire_interval: Timer = $FireDoT

export var explosion_damage: int
export var explosion_knockback: float
export var fire_damage: int
export var fire_knockback: float

signal exploded

func _ready():
	explosion_hitbox.damage = explosion_damage
	explosion_hitbox.knockback_strength = explosion_knockback
	fire_hitbox.damage = fire_damage
	fire_hitbox.knockback_strength = fire_knockback

func explode() -> void:
	emit_signal("exploded")
	yield(get_tree().create_timer(0.1), "timeout")
	explosion_collision.free()
	duration_timer.start()
	fire_interval.start()

func _on_FireDoT_timeout():
	#fire_collision.set_deferred("disabled", false)
	fire_collision.set_disabled(false)
	yield(get_tree().create_timer(0.1), "timeout")
	fire_collision.set_disabled(true)
	#fire_collision.set_deferred("disabled", true)

func _on_Duration_timeout():
	animation.play("fade")
