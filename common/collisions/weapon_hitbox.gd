extends Area2D
class_name WeaponHitbox

var _damage: int = 0 setget set_damage
var _character_damage: int = 0 setget set_character_damage
var knockback_strength: float


func _ready() -> void:
	randomize()
	knockback_strength = 0


func set_damage(new_damage: int) -> void:
	if new_damage > 0:
		_damage = new_damage
	else:
		_damage = 0


func set_character_damage(new_character_damage: int) -> void:
	if new_character_damage > 0:
		_character_damage = new_character_damage
	else:
		_character_damage = 0


func get_hitbox_damage() -> int:
	return _damage + _character_damage


func get_randomized_hitbox_damage() -> int:
	return _randomize_damage(_damage + _character_damage)


func _randomize_damage(damage: int) -> int:
	return int(round(rand_range(damage * 0.9, damage * 1.2)))
