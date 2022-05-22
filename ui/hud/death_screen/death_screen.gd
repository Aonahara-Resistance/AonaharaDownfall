extends CanvasLayer


func _on_AreaCheckpoint_pressed():
	Party.clear_party_members()

	Game.restart_scene_with_params({"restart": true})
