extends Area2D

export(int) var SPEED: int = 500
var damage = 1

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()

func _on_PlayerDagger_area_entered(_area):
	destroy()

func _on_PlayerDagger_body_entered(_body):
	destroy()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
