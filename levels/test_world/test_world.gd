extends Node2D

# * This thing is purposely messy for testing
export var player_path: NodePath
var res = preload("res://entities/characters/nom_nom/nom_nom.tscn").instance()
var res2 = preload("res://entities/characters/emuwaa/emuwaa.tscn").instance()
var player
var player_state
var dash
# warning-ignore:unsafe_method_access
var overlay = load("res://ui/debug_overlay/debug_overlay.tscn").instance()
var title = preload("res://ui/area_title/area_title.tscn").instance()


func _on_party_changed():
	player = Party.party_members[Party.selected_member]
	dash = player.get_node("Dash")
	player_state = player.get_node("StateMachine")
	overlay.stats.clear()
	set_debug_overlay()


func set_debug_overlay():
	overlay.add_stat("player speed", player, "velocity", false)
	overlay.add_stat("movement state", player_state, "_get_state_name", true)
	overlay.add_stat("is on battle: ", player, "get_is_in_battle", true)
	overlay.add_stat("can dash: ", dash, "can_dash", false)
	overlay.add_stat("dash cooldown: ", dash, "get_cooldown_timer", true)
	overlay.add_stat("stamina: ", player, "get_attribute", true, "stamina")
	overlay.add_stat("stamina regen timer: ", player, "get_stamina_timer", true)
	overlay.add_stat("hp: ", player, "get_attribute", true, "hp")


func _ready():
	Hud.visible = true
	var _singla = Party.connect("current_active_changed", self, "_on_party_changed")
	print(Party.add_party_member(res))
	print(Party.add_party_member(res2))
	print(Party.party_members)
	player = Party.party_members[Party.selected_member]
	Party.spawn_party(self)
	Party.set_selected_member(0)
	Party.tactical_character_showing(Party.current_character())

	add_child(overlay)
	add_child(title)
