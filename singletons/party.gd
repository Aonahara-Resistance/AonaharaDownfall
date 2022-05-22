extends Node

signal current_active_changed

var saved_party_members: Array = [
	preload("res://entities/characters/nom_nom/nom_nom.tscn"),
	preload("res://entities/characters/emuwaa/emuwaa.tscn"),
]
var saved_party: Array = []
var party_members: Array = []
const PARTY_MAX: int = 4
var selected_member: int = 0 setget set_selected_member, get_selected_member_index


func current_scene() -> Node:
	return get_tree().get_current_scene()


func load_party() -> void:
	for i in range(saved_party.size()):
		add_party_member(saved_party[i])


func is_party_empty() -> bool:
	if party_members.size() - 1 != -1:
		return false
	else:
		return true


func load_party_members() -> void:
	for i in range(saved_party_members.size()):
		add_party_member(saved_party_members[i].instance())


func switch_to_available_member() -> void:
	var death_count: int = 0
	for i in range(party_members.size()):
		if party_members[i].is_alive:
			change_party_member(i)
		else:
			death_count = death_count + 1
	print(death_count)
	if death_count == party_members.size():
		Hud.show_death_screen()


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
		Hud.show_info("she is die")
		return
	var pos = current_character().global_position
	tactical_character_hiding(current_character())
	var movement_key = current_character().movement_key
	set_selected_member(index)
	current_character().movement_key = movement_key
	current_character().global_position = pos
	tactical_character_showing(current_character())
	emit_signal("current_active_changed")
	Hud.update_hud()


func tactical_character_hiding(character) -> void:
	# ! Will break if the characters scene nodes renamed
	var sprites = [
		character.get_node("Sprite"),
		character.get_node("ShadowSprite"),
		character.get_node("Weapon"),
		character.get_node("StateLabel")
	]
	character.get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)
	character.is_in_control = false
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
	character.is_in_control = true
	for sprite in sprites:
		sprite.set_visible(true)
