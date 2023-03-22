extends CanvasLayer

func _on_AreaCheckpoint_pressed():
  GameSignal.emit_signal("death_continue_button_pressed")
  Game.restart_scene_with_params({"restart": true})
