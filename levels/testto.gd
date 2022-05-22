extends InteractableItem

var rocks = load("res://entities/enemies/chaser/fromb/fromb.tscn")
export var path: String


func interaction_interact(_interactionComponentParent: Node) -> void:
	for member in Party.party_members:
		Party.saved_party = []
		Party.saved_party.append(member)
		var character_parent = member.get_parent()
		character_parent.remove_child(member)
	Party.clear_party_members()
	Game.change_scene(
		path,
		{
			"destination": "SouthGate",
		}
	)
