extends Node2D

onready var canvas_modulate: CanvasModulate = $CanvasModulate
onready var checkpoint: Node2D = $Checkpoint
onready var spawn: Node2D = $Spawn


func pre_start(params):
	if params.has("restart"):
		Party.load_party_members()
		Party.spawn_at(checkpoint.global_position, $YSort)
	elif params.has("destination"):
		var destination_node: Node2D = get_node(params.destination)
		Party.load_party()
		Party.spawn_at(destination_node.global_position, $YSort)
	else:
		Party.load_party_members()
		Party.spawn_at(spawn.global_position, $YSort)


func _ready():
	Party.clear_party_members()
	Hud.visible = true
