extends PopupDialog


func _on_No_pressed():
	set_visible(false)


func _on_Yes_pressed():
	Game.change_scene(
		"res://scenes/opening/opening.tscn",
		{"show_texture": false, "show_tips": false, "show_progress_bar": false}
	)
