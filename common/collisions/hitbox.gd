extends Area2D
class_name Hitbox

var damage: int setget set_damage
var knockback_strength: float

func _ready() -> void:
	knockback_strength = 0

func randomize_damage(new_damage: int) -> int:
	randomize()
	return int(round(rand_range(new_damage * 0.9, new_damage * 1.2)))

func set_damage(new_damage: int) -> void:
	if new_damage > 0:
		damage = new_damage
	else:
		damage = 0

func get_hitbox_damage() -> int:
	return damage

func get_randomized_hitbox_damage() -> int:
	return randomize_damage(damage)
