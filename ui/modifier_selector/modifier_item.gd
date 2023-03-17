extends TextureButton

var modifier
onready var overlay: ColorRect = $Overlay


func _on_ModifierItem_pressed():
  GameSignal.emit_signal("modifier_item_button_pressed", load(modifier).instance())
#Party.current_character().apply_modifier(load(modifier).instance())


func _on_ModifierItem_mouse_entered():
  overlay.set_visible(true)


func _on_ModifierItem_mouse_exited():
  overlay.set_visible(false)
