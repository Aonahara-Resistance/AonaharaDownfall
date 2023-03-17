extends InteractableItem

var level
var destination: String


func interaction_interact(_interactionComponentParent: Node) -> void:
  GameSignal.emit_signal("wrap_interacted")
  Game.change_scene(
    level.get_path(),
    {
      "destination": destination,
    }
  )
