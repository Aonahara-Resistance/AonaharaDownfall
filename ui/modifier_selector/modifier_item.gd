extends TextureButton

var modifier


func _on_ModifierItem_pressed():
	Party.current_character().apply_modifier(load(modifier).instance())
