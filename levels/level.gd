extends Node2D
class_name Level

onready var canvas_modulate: CanvasModulate = $CanvasModulate
onready var checkpoint: Node2D = $Checkpoint
onready var spawn: Node2D = $Spawn
onready var ysort: YSort = $YSort

var is_using_game = false

func get_class() -> String:
  return "Level"

func is_class(value):
  if value == "Level":
    return true
  else:
    return false

func pre_start(params):
  print("prestart")
  is_using_game = true
  if params.has("restart"):
    GameSignal.emit_signal("level_restarted", checkpoint.global_position, ysort)
  elif params.has("destination"):
    var destination_node: Node2D = get_node(params.destination)
    GameSignal.emit_signal("level_loaded_with_destionation", destination_node.global_position, ysort)
  else:
    GameSignal.emit_signal("level_loaded", spawn.global_position, ysort)

func _ready():
  GameSignal.emit_signal("level_entered")
  var new_dialog = Dialogic.start('test')
  add_child(new_dialog)
