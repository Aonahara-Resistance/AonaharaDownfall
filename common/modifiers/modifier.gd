extends Node2D
class_name Modifier

enum Types { Buff, Debuff }
export(Types) var type = Types.Buff

export var buff_name: String
export var buff_icon: Resource
export(String, MULTILINE) var buff_description: String
export var duration: float
onready var duration_timer: Timer = $Duration
export var effect: PackedScene
var instanced_effect


func _ready():
	duration_timer.set_wait_time(duration)
	duration_timer.start()
	if effect != null:
		var effect_container = get_node("../../Vfx")
		instanced_effect = effect.instance()
		effect_container.add_child(instanced_effect)
	Hud.update_hud()
	Hud.register_buff()


func modify_stateless(res):
	print(res)
	return res


func modify_stateful(host):
	print(host)
	pass


func _on_Duration_timeout():
	print(name)
	if effect != null:
		instanced_effect.get_parent().remove_child(instanced_effect)
		instanced_effect.queue_free()
	call_deferred("queue_free")


func reset_duration():
	print("reset timer")
	duration_timer.start()
