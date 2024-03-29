extends PopupDialog

onready var hover: AudioStreamPlayer = $Hover

func _on_No_pressed() -> void:
  set_visible(false)

func _on_Yes_pressed() -> void:
  var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
  var start: AudioStreamPlayer = $Start
  sfx.stream = start.stream
  sfx.connect("finished", sfx, "queue_free")
  get_tree().root.add_child(sfx) 
  sfx.pause_mode = PAUSE_MODE_PROCESS
  sfx.play()
  Game.change_scene(
    "res://levels/demo/demo.tscn",
    {"show_texture": false, "show_tips": false, "show_progress_bar": false}
  )

func _on_No_mouse_entered() -> void:
  hover.play()

func _on_Yes_mouse_entered() -> void:
  hover.play()

func _on_No_focus_entered() -> void:
  hover.play()

func _on_Yes_focus_entered() -> void:
  hover.play()
