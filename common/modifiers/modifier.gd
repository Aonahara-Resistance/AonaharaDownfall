extends Node2D
class_name Modifier

enum Types { Buff, Debuff }
export(Types) var type = Types.Buff

export var buff_name: String
export var buff_icon: Resource
export(String, MULTILINE) var buff_description: String
export var duration: float
export var effect: PackedScene

onready var duration_timer: Timer = $Duration

var instanced_effect
var is_active

signal modifier_ended


func _ready():
  is_active = true
  duration_timer.set_wait_time(duration)
  duration_timer.start()
  if effect != null:
    # Assumption is evil
    # but hey idk it works 
    # it it doesn;'t'
    var effect_container = get_node("../../Vfx")
    instanced_effect = effect.instance()
    effect_container.add_child(instanced_effect)

func modify_stateless(res):
  return res

func modify_stateful(_host):
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
  queue_free()
  is_active = false
  emit_signal("modifier_ended")
