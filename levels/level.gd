extends Node2D
class_name Level

onready var canvas_modulate: CanvasModulate = $CanvasModulate
onready var checkpoint: Node2D = $Checkpoint
onready var spawn: Node2D = $Spawn
onready var ysort: YSort = $YSort


func get_class() -> String:
  return "Level"


func is_class(value):
  if value == "Level":
    return true
  else:
    return false


func pre_start(params):
  if params.has("restart"):
    print("a")
    GameSignal.emit_signal("level_restarted", checkpoint.global_position, ysort)
  elif params.has("destination"):
    print("b")
    var destination_node: Node2D = get_node(params.destination)
    GameSignal.emit_signal("level_loaded_with_destionation", destination_node.global_position, ysort)
  else:
    print("c")
    GameSignal.emit_signal("level_loaded", spawn.global_position, ysort)


func _ready():
  GameSignal.emit_signal("level_entered")
