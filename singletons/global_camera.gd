extends Node2D

onready var camera2D: Camera2D = $Camera2D


func _process(_delta):
	if Party.current_character() != null && Party.party_members != []:
		camera2D.current = true
		global_position = Party.current_character().global_position
	else:
		camera2D.current = false


func set_current(state: bool) -> void:
	camera2D.current = state


func get_camera():
	return camera2D
