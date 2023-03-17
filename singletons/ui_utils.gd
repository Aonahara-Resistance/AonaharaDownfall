extends Node

var popup = preload("res://ui/hud/popup_info/popup_info.tscn")

func show_info(info: String) -> void:
  var popup_instance = popup.instance()
  get_tree().current_scene.add_child(popup_instance)
  popup_instance.pop_info(info)
