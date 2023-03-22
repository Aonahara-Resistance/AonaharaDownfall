extends Control

var params = {
	show_progress_bar = false,
	show_tips = false,
	show_texture = false,
}

func _on_Button_pressed():
	Game.change_scene("res://menus/main_menu/main_menu.tscn", params)
