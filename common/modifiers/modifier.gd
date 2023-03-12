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
    # Assumption is evil
    var effect_container = get_node("../../Vfx")
    instanced_effect = effect.instance()
    effect_container.add_child(instanced_effect)


func modify_stateless(res):
  return res


func modify_stateful(host):
  pass


func reset_duration():
  print("reset timer")
  GameSignal.emit_signal("modifier_reset")
  duration_timer.start()


func get_modifier_type() -> int:
  return type


func _on_Duration_timeout():
  if effect != null:
    instanced_effect.get_parent().remove_child(instanced_effect)
    instanced_effect.queue_free()
  call_deferred("queue_free")
