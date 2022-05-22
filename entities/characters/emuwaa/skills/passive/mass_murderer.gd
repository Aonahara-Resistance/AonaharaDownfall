extends Area2D

var skill_name: String = "Mass Murderer"
var skill_description: String = ""
var skill_level: int = 1
var isConditionMet: bool = true

export var character_path: NodePath
export var damage_bonus: int = 2

onready var character = get_node(character_path)
onready var collision = $CollisionShape2D


func _on_MassMurderer_body_exited(body: Node) -> void:
	if body is Enemy && isConditionMet:
		character.base_damage -= damage_bonus


func _on_MassMurderer_body_entered(body: Node) -> void:
	if body is Enemy && isConditionMet:
		character.base_damage += damage_bonus
