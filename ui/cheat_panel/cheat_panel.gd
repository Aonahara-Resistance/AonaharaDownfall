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
  GameSignal.emit_signal("reset_modifier_button_pressed")


func _on_ResetStats_pressed():
  GameSignal.emit_signal("reset_stats_button_pressed")


func _on_InfHealth_pressed():
  GameSignal.emit_signal("inf_health_button_pressed", inf_health_button.pressed)


func _on_InfStamina_pressed():
  GameSignal.emit_signal("inf_stamina_button_pressed", inf_stamina_button.pressed)
