extends NinePatchRect

onready var atlas = $TextureRect

var index

func _on_ReserveItem_gui_input(event:InputEvent):
  if event.is_action_pressed("left_click"):
    $PopupDialog.rect_position = get_global_mouse_position()
    $PopupDialog.popup()

func _on_PopupDialog_popup_hide():
  pass

func _on_Label_gui_input(event:InputEvent):
  if event.is_action_pressed("left_click"):
    GameSignal.emit_signal("deploy_reserve_requested", index)

func _on_CancelLabel_gui_input(event:InputEvent):
  if event.is_action_pressed("left_click"):
    GameSignal.emit_signal("deploy_reserve_cancelled")
