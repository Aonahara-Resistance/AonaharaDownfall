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
		Party.load_party_members()
		Party.spawn_at(checkpoint.global_position, ysort)
	elif params.has("destination"):
		var destination_node: Node2D = get_node(params.destination)
		Party.load_party()
		Party.spawn_at(destination_node.global_position, ysort)
	else:
		Party.load_party_members()
		Party.spawn_at(spawn.global_position, ysort)


func _ready():
	Party.clear_party_members()
#Hud.visible = true
