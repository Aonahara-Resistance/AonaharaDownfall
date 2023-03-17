extends Node

var saved_party_members: Array = [
  preload("res://entities/characters/nom_nom/nom_nom.tscn"),
  preload("res://entities/characters/emuwaa/emuwaa.tscn"),
]
var saved_party: Array = []
var party_members: Array = []
const PARTY_MAX: int = 3
var selected_member: int = 0 setget set_selected_member, get_selected_member_index


func _ready():
  connect_signals()


func current_scene() -> Node:
  return get_tree().get_current_scene()


func load_party() -> void:
  for i in range(saved_party.size()):
    add_party_member(saved_party[i])

func load_party_members() -> void:
  for i in range(saved_party_members.size()):
    add_party_member(saved_party_members[i].instance())

func is_party_empty() -> bool:
  if party_members.size() - 1 != -1:
    return false
  else:
    return true

func switch_to_available_member() -> void:
  var death_count: int = 0
  for i in range(party_members.size()):
    if party_members[i].is_alive:
      change_party_member(i)
    else:
      death_count = death_count + 1
  print(death_count)
  if death_count == party_members.size():
    GameSignal.emit_signal("died")


func clear_party_members() -> void:
  party_members = []
  set_selected_member(0)


func set_selected_member(index: int) -> void:
  selected_member = index


func get_selected_member_index() -> int:
  return selected_member


func spawn_party(target_node) -> void:
  for member in party_members:
    target_node.add_child(member)
  tactical_character_showing(current_character())


func spawn_at(location: Vector2, target_node: YSort) -> void:
  for member in party_members:
    member.global_position = location
    target_node.add_child(member)
  tactical_character_showing(current_character())
  GameSignal.emit_signal("party_spawned", current_character())


func add_party_member(member) -> void:
  if party_members.size() < PARTY_MAX:
    party_members.append(member)
  else:
    # TODO: pop up notice party max
    pass


func remove_party_member(index: int) -> void:
  party_members.remove(index)


# TODO: Swap party member


func current_character() -> Character:
  if !is_party_empty():
    return party_members[get_selected_member_index()]
  else:
    # TODO: Handle if part is empty
    return null


func change_party_member(index) -> void:
  if !party_members[index].is_alive:
    UiUtils.show_info("she is die")
    return
  if index == get_selected_member_index():
    return
  tactical_character_hiding(current_character())
  var pos = current_character().global_position
  var movement_key = current_character().movement_key
  set_selected_member(index)
  current_character().movement_key = movement_key
  current_character().global_position = pos
  tactical_character_showing(current_character())
  emit_signal("active_party_switched", current_character())


func tactical_character_hiding(character) -> void:
  # ! Will break if the characters scene nodes renamed
  character.is_in_control = false
  var sprites = [
    character.get_node("Sprite"),
    character.get_node("ShadowSprite"),
    character.get_node("Weapon"),
    character.get_node("StateLabel")
  ]
  character.get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)
  character.get_node("InteractionComponent/CollisionShape2D").set_deferred("disabled", true)
  character.get_node("CollisionShape2D").set_deferred("disabled", true)
  for sprite in sprites:
    sprite.set_visible(false)


func tactical_character_showing(character) -> void:
  # ! Will break if the characters scene nodes renamed
  var sprites = [
    character.get_node("Sprite"),
    character.get_node("ShadowSprite"),
    character.get_node("Weapon"),
    character.get_node("StateLabel")
  ]
  character.get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", false)
  character.get_node("InteractionComponent/CollisionShape2D").set_deferred("disabled", false)
  character.get_node("CollisionShape2D").set_deferred("disabled", false)
  for sprite in sprites:
    sprite.set_visible(true)
  character.is_in_control = true

func _on_level_restarted(destination, target_node) -> void:
  load_party_members()
  spawn_at(destination, target_node)

func _on_level_loaded(destination, target_node) -> void:
  load_party_members()
  spawn_at(destination, target_node)

func _on_level_loaded_with_desination(destination, target_node) -> void:
  load_party()
  spawn_at(destination, target_node)

func _on_level_entered() -> void:
  clear_party_members()
  
func _on_party_member_change_requested(index) -> void:
  if party_members.size() >= index:
    change_party_member(index)
    GameSignal.emit_signal("party_member_changed", current_character())

func _on_party_member_died() -> void:
  tactical_character_hiding(current_character())
  switch_to_available_member()

func _on_skill_one_pressed() -> void:
  current_character().skill_one.activate_skill()

func _on_skill_two_pressed() -> void:
  current_character().skill_two.activate_skill()

func _on_death_restart_button_pressed() -> void:
  clear_party_members()

func _on_reset_modifier_button_pressed() -> void:
  current_character().reset_modifier()

func _on_reset_stats_button_pressed()->void:
  current_character().reset_stats()

func _on_inf_health_button_pressed(state) -> void:
  current_character().inf_health = state

func _on_inf_stamina_button_pressed(state) -> void:
  current_character().inf_stamina = state

func _on_modifier_item_button_pressed(modifier) -> void:
  current_character().apply_modifier(modifier)

func _on_warp_interacted() -> void:
  saved_party = []
  for member in party_members:
    saved_party.append(member)
    member.get_parent().remove_child(member)
  clear_party_members()

func _on_main_menu_button_pressed() -> void:
  party_members = []



func connect_signals()->void:
  GameSignal.connect("level_restarted", self, "_on_level_restarted")
  GameSignal.connect("level_loaded", self, "_on_level_loaded")
  GameSignal.connect("level_loaded_with_destination", self, "_on_level_loaded_with_destination")
  GameSignal.connect("level_entered", self, "_on_level_entered")

  GameSignal.connect("party_member_change_requested", self, "_on_party_member_change_requested")
  GameSignal.connect("party_member_died", self, "_on_party_member_died")

  GameSignal.connect("skill_one_pressed", self, "_on_skill_one_pressed")
  GameSignal.connect("skill_two_pressed", self, "_on_skill_two_pressed")

  GameSignal.connect("death_restart_button_pressed", self, "_on_death_restart_button_pressed")

  GameSignal.connect("reset_modifier_button_pressed", self, "_on_reset_modifier_button_pressed")
  GameSignal.connect("reset_stats_button_pressed", self, "_on_reset_stats_button_pressed")
  GameSignal.connect("inf_health_button_pressed", self, "_on_inf_health_button_pressed")
  GameSignal.connect("inf_stamina_button_pressed", self, "_on_inf_stamina_button_pressed")
  GameSignal.connect("modifier_item_button_pressed", self, "_on_modifier_item_button_pressed")

  GameSignal.connect("warp_interacted", self, "_on_warp_interacted")

  GameSignal.connect("main_menu_button_pressed", self, "_on_main_menu_button_pressed")
