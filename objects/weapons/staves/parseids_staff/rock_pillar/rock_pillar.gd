extends StaticBody2D

onready var animation: AnimationPlayer = $AnimationPlayer


func crumble():
	animation.play("crumble")


func _on_Timer_timeout():
	crumble()


func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "crumble":
		queue_free()
