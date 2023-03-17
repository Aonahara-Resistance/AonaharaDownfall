extends Node2D

onready var camera2D: Camera2D = $Camera2D


func _process(_delta):
	if !Party.is_party_empty():
		camera2D.current = true
		global_position = Party.current_character().global_position
	else:
		camera2D.current = false
