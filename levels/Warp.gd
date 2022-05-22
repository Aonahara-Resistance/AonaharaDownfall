extends Node2D

export var destination: PackedScene
export var options: PackedScene
onready var interaction = $InteractableItem
onready var collision: CollisionShape2D = $Area2D/CollisionShape2D


func _on_Area2D_body_entered(body: Node):
	print("entered")
	Engine.set_time_scale(0.1)
	for member in Party.party_members:
		member.get_parent().remove_child(member)
		Party.saved_party.append(member)
	Party.clear_party_members()
	Game.change_scene(
		"res://levels/level.tscn",
		{
			"destination": "SouthGate",
		}
	)
