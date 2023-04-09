extends Control

onready var tos = $NinePatchRect
onready var label = $NinePatchRect/MarginContainer/VBoxContainer2/Label

var ready = false
var button_clicked = false

var params = {
  show_progress_bar = false,
  show_tips = false,
  show_texture = false,
}

func _ready():
  var tween = get_tree().create_tween()
  tween.tween_property(tos, "modulate", Color(1,1,1,1), 1)
  tween.tween_property(label, "percent_visible", 1.0, 2)
  yield(tween.tween_property($NinePatchRect/MarginContainer/VBoxContainer2/Button, "modulate", Color(1,1,1,1), 0.3), "finished")
  ready = true

func _on_Button_pressed():
  if ready:
    button_clicked = true
    var sfx = AudioStreamPlayer.new()
    sfx.stream = $Click.stream
    sfx.connect("finished", sfx, "queue_free")
    get_tree().root.add_child(sfx) 
    sfx.play()
    Game.change_scene("res://menus/main_menu/main_menu.tscn", params)


func _on_Button_mouse_entered():
  if ready:
    $AudioStreamPlayer.play()

func _unhandled_input(event: InputEvent):
  if event.is_action_pressed("tab", true):
    print(get_focus_owner())
    if get_focus_owner() == $NinePatchRect/MarginContainer/VBoxContainer2/Button:
      $NinePatchRect/MarginContainer/VBoxContainer2/Button.release_focus()
    else:
      $NinePatchRect/MarginContainer/VBoxContainer2/Button.grab_focus()
      if ready:
        $AudioStreamPlayer.play()
