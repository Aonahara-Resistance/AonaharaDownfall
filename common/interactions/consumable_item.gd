extends InteractableItem
class_name ConsumableItem

export var interaction_texture: Texture = preload("res://assets/place_holder/props_itens/key_silver.png")


func interaction_get_texture() -> Texture:
	return interaction_texture


func interaction_get_text() -> String:
	return "Drink"
