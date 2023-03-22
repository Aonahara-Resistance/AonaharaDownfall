extends Control
class_name InteractionComponentUI

export var interaction_component_nodepath: NodePath

export var interaction_texture_nodepath: NodePath
export var interaction_text_nodepath: NodePath
export var interaction_default_texture: Texture
export var interaction_default_text: String

var fixed_position: Vector2

func _ready() -> void:
	hide()
