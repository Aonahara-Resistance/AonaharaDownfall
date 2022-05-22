extends Node2D


func finish():
	var dialog = Dialogic.start("op_title")
	dialog.connect("dialogic_signal", self, "dialog_listener")
	add_child(dialog)


func dialog_listener(_arg):
	Game.change_scene("res://scenes/train/train.tscn", {"show_texture": false, "show_tips": false})
