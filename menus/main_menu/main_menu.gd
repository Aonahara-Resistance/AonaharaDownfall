extends CanvasLayer

onready var new_game_popup: PopupDialog = $CenterPopup/NewGamePopup
onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton

onready var hover: AudioStreamPlayer = $Hover

func _ready() -> void:
  if OS.has_feature("HTML5"):
    $CenterContainer/VBoxContainer/QuitButton.queue_free()

# ???
func _on_OptionButton_pressed() -> void:
  pass

func _on_PlayButton_pressed() -> void:
  print("play")
  new_game_popup.popup()
  var pop: AudioStreamPlayer = $Pop
  pop.play()

func _on_test_pressed() -> void:
  Game.change_scene(
    "res://levels/firing_range/firing_range.tscn",
    {
      show_progress_bar = true,
    }
  )

func _on_QuitButton_pressed() -> void:
  var quit: AudioStreamPlayer = $Quit
  quit.play()
  var transitions = get_node_or_null("/root/Transitions")
  if transitions:
    transitions.fade_in({"show_progress_bar": false})
    yield(transitions.anim, "animation_finished")
    yield(get_tree().create_timer(0.3), "timeout")
  get_tree().quit()



func _on_QuitButton_focus_entered():
  hover.play()

func _on_PlayButton_mouse_entered():
  hover.play()

func _on_PlayButton_focus_entered():
  hover.play()

func _on_QuitButton_mouse_entered():
  hover.play()

