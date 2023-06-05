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

var active_character_name: String

func _ready() -> void:
  _connect_signals()

func update_modifier_indicator(character) -> void:
  for modifier in modifier_container.get_children():
    modifier_container.remove_child(modifier)
    modifier.call_deferred("queue_free")
  for modifier in character.get_modifiers():
    var buff_item_instance = buff_indicator.instance()
    buff_item_instance.set_texture(modifier.buff_icon)
    buff_item_instance.get_node("CooldownIndicator").max_value = modifier.duration * 60
    buff_item_instance.get_node("CooldownIndicator").value = (
      modifier.duration * 60
      - modifier.get_node("Duration").time_left * 60
    )
    print(modifier.get_node("Duration").time_left)
    modifier_container.add_child(buff_item_instance)

func show_death_screen():
  get_tree().current_scene.add_child(death_screen.instance())

func _process(delta):
  if channeling.is_visible():
    channeling.value += 1 * delta * 60

func start_channeling(duration: float) -> void:
  channeling.set_value(0)
  channeling.set_visible(true)
  channeling.set_max(duration)

func _on_Progress_value_changed(value: float):
  if value == channeling.get_max():
    channeling.set_visible(false)

func update_health(character) -> void:
  for i in health_container.get_children():
    i.free()
  for i in empty_health_container.get_children():
    i.free()
  for i in character.get_attribute("hp"):
    health_container.add_child(health_full.instance())
  for i in character.get_attribute("max_hp"):
    empty_health_container.add_child(health_empty.instance())

func update_stamina(character) -> void:
  for i in stamina_container.get_children():
    #stamina_container.remove_child(i)
    i.free()
  for i in stamina_fill.get_children():
    #stamina_fill.remove_child(i)
    i.free()
  for i in character.get_attribute("stamina"):
    stamina_fill.add_child(stamina_bar_filled.instance())
  for i in character.get_attribute("max_stamina"):
    stamina_container.add_child(stamina_bar_empty.instance())

func _on_Dash_started(character) -> void:
  update_stamina(character)

func _on_party_member_changed(character) -> void:
  update_modifier_indicator(character)
  update_health(character)
  update_stamina(character)
  character_icon.set_texture(character.character_icon)
  active_character_name = character.character_name

func _on_modifier_applied(character) -> void:
  update_modifier_indicator(character)
  update_health(character)
  update_stamina(character)

func _on_modifier_reset(character) -> void:
  update_health(character)
  update_stamina(character)
  update_modifier_indicator(character)

func _on_modifier_ended(character) -> void:
  print(character.get_modifiers())
  update_health(character)
  update_stamina(character)

func _on_skill_channel_started(duration) -> void:
  start_channeling(duration)

func _on_died() -> void:
  show_death_screen()

func _on_party_spawned(active_character, _party_members, _reserved) -> void:
  update_health(active_character)
  update_stamina(active_character)
  character_icon.set_texture(active_character.character_icon)
  active_character_name = active_character.character_name

func _on_health_changed(character) -> void:
  if character.character_name == active_character_name:
    update_health(character)

func _on_stamina_changed(character) -> void:
  if character.character_name == active_character_name:
    update_stamina(character)

func _on_level_entered() -> void:
  gui.visible = true
  get_tree().create_tween().tween_property(gui, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_SINE)

func _on_cutscene_started() -> void:
  var tween = get_tree().create_tween()
  tween.set_pause_mode(PAUSE_MODE_PROCESS)
  yield(tween.tween_property(gui, "modulate", Color.transparent, 0.5).set_trans(Tween.TRANS_SINE), "finished")
  gui.visible = false

func _on_cutscene_ended(_pos) -> void:
  gui.visible = true
  get_tree().create_tween().tween_property(gui, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_SINE)

func _connect_signals() -> void:
  GameSignal.connect("dash_started", self, "_on_Dash_started")
  GameSignal.connect("modifier_applied", self, "_on_modifier_applied")
  GameSignal.connect("modifier_reset", self, "_on_modifier_reset")
  GameSignal.connect("modifier_ended", self, "_on_modifier_ended")
  GameSignal.connect("skill_channel_started", self, "_on_skill_channel_started")
  GameSignal.connect("died", self, "_on_died")
  GameSignal.connect("party_member_changed", self, "_on_party_member_changed")
  GameSignal.connect("party_spawned", self, "_on_party_spawned")
  GameSignal.connect("health_changed", self, "_on_health_changed")
  GameSignal.connect("stamina_changed", self, "_on_stamina_changed")
  GameSignal.connect("level_entered", self, "_on_level_entered")

  GameSignal.connect("cutscene_started", self, "_on_cutscene_started")
  GameSignal.connect("cutscene_ended", self, "_on_cutscene_ended")

