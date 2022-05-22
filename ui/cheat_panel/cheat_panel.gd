extends CanvasLayer

onready var cheat_ui: Control = $CheatUi
onready var inf_health_button: CheckBox = $CheatUi/VBoxContainer/InfHealth
onready var inf_stamina_button: CheckBox = $CheatUi/VBoxContainer/InfStamina
export var modifier_selector_scene: PackedScene

var modifier_selector


func _ready():
	modifier_selector = modifier_selector_scene.instance()
	add_child(modifier_selector)


func _unhandled_input(event):
	if event.is_action_pressed("cheat"):
		cheat_ui.set_visible(!cheat_ui.visible)


func _on_ModifierSelector_pressed():
	modifier_selector.dialog.popup()


func _on_ResetModifier_pressed():
	Party.current_character().reset_modifier()


func _on_ResetStats_pressed():
	Party.current_character().reset_stats()


func _on_InfHealth_pressed():
	Party.current_character().inf_health = inf_health_button.pressed


func _on_InfStamina_pressed():
	Party.current_character().inf_stamina = inf_stamina_button.pressed
