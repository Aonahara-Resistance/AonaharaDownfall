extends Area2D
class_name WeaponHitbox

# The difference between normal hitbox is that
# Weapon hitbox require character damage

var damage: int
var knockback_strength: float


func total_damage() -> int:
	return damage + Party.current_character().get_attribute("base_damage")
