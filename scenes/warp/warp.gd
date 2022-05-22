extends StaticBody2D
class_name Warp

onready var interaction = $Interaction

export var level: PackedScene
export var destination: String


func _ready():
	interaction.level = level
	interaction.destination = destination
