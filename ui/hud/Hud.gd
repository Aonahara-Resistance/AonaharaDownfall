extends Node

export var pop_up: PackedScene
export var death_screen: PackedScene
export var buff_indicator: PackedScene

onready var gui: Control = $CanvasLayer/GUI
onready var health_container: HBoxContainer = $CanvasLayer/GUI/MarginContainer/Top/Health
onready var empty_health_container: HBoxContainer = $CanvasLayer/GUI/MarginContainer/TopBackground/HealthEmpty
onready var stamina_fill: HBoxContainer = $CanvasLayer/GUI/MarginContainer/Top/Stamina
onready var stamina_container: HBoxContainer = $CanvasLayer/GUI/MarginContainer/TopBackground/StaminaFill
onready var skill: SkillHud = $CanvasLayer/GUI/MarginContainer2/Bottom/SkillsHud
onready var channeling: TextureProgress = $CanvasLayer/GUI/MarginContainer2/Bottom/Channeling/Progress
onready var character_icon: TextureRect = $CanvasLayer/GUI/MarginContainer3/HBoxContainer/CharacterIcon
onready var modifier_container: HBoxContainer = $CanvasLayer/GUI/MarginContainer4/Modifiers

var health_full = preload("res://ui/hud/health/health_full.tscn")
var health_empty = preload("res://ui/hud/health/health_empty.tscn")
var stamina_bar_empty = preload("res://ui/hud/stamina/stamina_bar_empty.tscn")
var stamina_bar_filled = preload("res://ui/hud/stamina/stamina_bar_filled.tscn")

var visible := false setget set_visible


func _ready() -> void:
	var _err = Party.connect("active_party_switched", self, "_on_party_changed")
	gui.visible = visible
	update_hud()


func _on_party_changed():
	print("ayo")


func update_hud() -> void:
	if !Party.is_party_empty():
		_update_health()
		_update_stamina()
		skill.update_skill()
		character_icon.set_texture(Party.current_character().character_icon)


func show_info(info: String):
	var popup: PopupInfo = pop_up.instance()
	get_tree().current_scene.add_child(popup)
	popup.show_info(info)


func show_death_screen():
	get_tree().current_scene.add_child(death_screen.instance())


func _process(delta):
	update_hud()
	if channeling.is_visible():
		channeling.value += 1 * delta * 60


func start_channeling(duration: float) -> void:
	channeling.set_value(0)
	channeling.set_visible(true)
	channeling.set_max(duration)


func _on_Progress_value_changed(value: float):
	if value == channeling.get_max():
		channeling.set_visible(false)


func register_buff() -> void:
	modifier_container.add_child(buff_indicator.instance())


func _update_health() -> void:
	for i in health_container.get_children():
		#health_container.remove_child(i)
		i.free()

		#empty_health_container.remove_child(i)
	for i in empty_health_container.get_children():
		i.free()
		#empty_health_container.remove_child(i)
	for i in Party.current_character().get_attribute("hp"):
		health_container.add_child(health_full.instance())
	for i in Party.current_character().get_attribute("max_hp"):
		empty_health_container.add_child(health_empty.instance())


func _update_modifiers() -> void:
	for modifier in Party.current_character().get_modifiers():
		for modifier_indicator in modifier_container.get_children():
			if modifier.buff_name != modifier_indicator.buff_name:
				modifier_indicator.call_deferred(queue_free())


func _update_stamina() -> void:
	for i in stamina_container.get_children():
		#stamina_container.remove_child(i)
		i.free()
	for i in stamina_fill.get_children():
		#stamina_fill.remove_child(i)
		i.free()
	for i in Party.current_character().get_attribute("stamina"):
		stamina_fill.add_child(stamina_bar_filled.instance())
	for i in Party.current_character().get_attribute("max_stamina"):
		stamina_container.add_child(stamina_bar_empty.instance())


func set_visible(value: bool) -> void:
	visible = value
	gui.visible = value
