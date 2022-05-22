extends Explosive

export var speed: int = 200
var direction = Vector2.ZERO
onready var animation: AnimationPlayer = $AnimationPlayer
onready var explosion_collision: CollisionShape2D = $ExplosionHitbox/CollisionShape2D
onready var explosion: Area2D = $ExplosionHitbox
var formed: bool = false


func disable():
	.disable()
	speed = 0
	yield(get_tree().create_timer(0.1), "timeout")
	explosion_collision.free()


func launch():
	var angle_to_mouse = ((get_global_mouse_position() - Party.current_character().global_position).normalized()).angle()
	rotate(angle_to_mouse)
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x < 0:
		sprite.scale.y *= -1
		explosion.scale.y *= -1


func _process(delta):
	if formed:
		global_position += speed * direction * delta


func set_formed():
	formed = true
	animation.play("swim")


func _on_Audio_finished():
	queue_free()
