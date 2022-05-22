extends Node2D
class_name Modifier

enum Types { Buff, Debuff }
export(Types) var type = Types.Buff

export var buff_name: String
export var buff_icon: Resource
export(String, MULTILINE) var buff_description: String
export var duration: float
onready var duration_timer: Timer = $Duration


func _ready():
	duration_timer.set_wait_time(duration)
	duration_timer.start()
	Hud.update_hud()


func modify_stateless(res):
	print(res)
	pass


func modify_stateful(host):
	print(host)
	pass


func _on_Duration_timeout():
	call_deferred("queue_free")


func reset_duration():
	print("reset timer")
	duration_timer.start()
