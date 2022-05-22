extends InteractableItem

var level
var destination: String


func interaction_interact(_interactionComponentParent: Node) -> void:
	Party.saved_party = []
	for member in Party.party_members:
		Party.saved_party.append(member)
		member.get_parent().remove_child(member)
	Party.clear_party_members()
	Game.change_scene(
		level.get_path(),
		{
			"destination": destination,
		}
	)
