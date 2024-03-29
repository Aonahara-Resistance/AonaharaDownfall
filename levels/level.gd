extends Node2D
class_name Level

onready var gameplay: Node2D = $Gameplay
onready var cutscene: Node2D = $Cutscene
onready var bgm: AudioStreamPlayer = $Gameplay/BGM
onready var canvas_modulate: CanvasModulate = $CanvasModulate
onready var checkpoint: Node2D = $Gameplay/Checkpoint
onready var spawn: Node2D = $Gameplay/Spawn
onready var ysort: YSort = $Gameplay/YSort
onready var camera_c: Camera2D = $Cutscene/Camera2D
onready var animation_bar: AnimationPlayer  = $Bar/AnimationPlayer

export var area_title: PackedScene


func get_class() -> String:
  return "Level"

func is_class(value):
  if value == "Level":
    return true
  else:
    return false

func pre_start(params):
  if params.has("restart"):
    GameSignal.emit_signal("level_restarted", checkpoint.global_position, ysort)
  elif params.has("destination"):
    var destination_node: Node2D = get_node(params.destination)
    GameSignal.emit_signal("level_loaded_with_destionation", destination_node.global_position, ysort)
  else:
    GameSignal.emit_signal("level_loaded", spawn.global_position, ysort)

func _ready():
  GameSignal.emit_signal("level_entered")
