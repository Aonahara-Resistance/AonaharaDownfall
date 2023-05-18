extends Control

onready var tos = $NinePatchRect
onready var label = $NinePatchRect/MarginContainer/VBoxContainer2/Label
onready var play_button: Button = $NinePatchRect/MarginContainer/VBoxContainer2/Button

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
    var click: AudioStreamPlayer = $Click
    sfx.stream = click.stream
    sfx.connect("finished", sfx, "queue_free")
    get_tree().root.add_child(sfx) 
    sfx.play()
    Game.change_scene("res://menus/main_menu/main_menu.tscn", params)


func _on_Button_mouse_entered():
  if ready:
    var audio: AudioStreamPlayer = $AudioStreamPlayer
    audio.play()

func _unhandled_input(event: InputEvent):
  if event.is_action_pressed("tab", true):
    print(get_focus_owner())
    if get_focus_owner() == $NinePatchRect/MarginContainer/VBoxContainer2/Button:
      play_button.release_focus()
    else:
      play_button.grab_focus()
      if ready:
        var audio: AudioStreamPlayer = $AudioStreamPlayer
        audio.play()
