extends Area2D
class_name AlertSignal

onready var collision: CollisionShape2D = $CollisionShape2D
onready var animation: AnimationPlayer = $AnimationPlayer
onready var audio: AudioStreamPlayer2D = $Audio
onready var receiver: CollisionShape2D = $Receiver/CollisionShape2D
onready var parent = get_parent()
signal alerted


func _ready():
	receiver.set_shape(collision.get_shape())


func alert():
	animation.play("alert")
	collision.set_deferred("disabled", false)
	yield(get_tree().create_timer(0.5), "timeout")
	collision.set_deferred("disabled", true)


func _on_Receiver_area_entered(area):
	if !area.has_method("alert"):
		return
	animation.play("alert")
	parent.target = area.get_parent().target
	print("alerted")
	emit_signal("alerted")
