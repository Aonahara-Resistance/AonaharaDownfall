extends Node2D

onready var camera2D: Camera2D = $Camera2D
var camera_target_offset = Vector2.ZERO
var camera_speed = 1
# Physics cock, not the render cock: the body it follows moves in
# _physics_process, and a camera gliding between physics ticks is what makes the
# player wobble against the background on a monitor faster than physics_fps.
func _physics_process(_delta):
  # Experimental: 
  # var mouse_position = get_viewport().get_mouse_position()
  # camera_target_offset = (mouse_position - get_viewport_rect().size / 2.0) / 0.2
  # var current_offset = camera2D.offset
  # var new_offset = current_offset.linear_interpolate(camera_target_offset, camera_speed * delta)
  # camera2D.offset = new_offset
  if !Party.is_party_empty():
    camera2D.current = true
    global_position = Party.current_character().global_position
  else:
    camera2D.current = false
