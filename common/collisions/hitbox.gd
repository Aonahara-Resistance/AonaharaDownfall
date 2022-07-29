extends Area2D
class_name Hitbox

var _damage: int setget set_damage
var knockback_strength: float


func _ready():
	randomize()
	knockback_strength = 0


func _randomize_damage(damage: int) -> int:
	return int(round(rand_range(damage * 0.9, damage * 1.2)))


func set_damage(damage: int) -> void:
	if damage > 0:
		_damage = damage
	else:
		_damage = 0


func get_hitbox_damage() -> int:
	return _damage


func get_randomized_hitbox_damage() -> int:
	return _randomize_damage(_damage)
