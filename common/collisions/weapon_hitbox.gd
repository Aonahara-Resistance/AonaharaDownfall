extends Hitbox
class_name WeaponHitbox

var _character_damage: int = 0


func get_damage() -> int:
	return _damage + _character_damage
