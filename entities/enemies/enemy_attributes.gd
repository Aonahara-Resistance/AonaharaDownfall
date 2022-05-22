extends Resource
class_name EnemeyAttributes


func _init(
	hp: int,
	max_hp: int,
	max_speed: int,
	base_damage: int,
	acceleration: int,
	friction: float,
	steering_force: float,
	avoid_force: float,
	receives_knockback: bool
):
	stateful_attributes.hp = hp
	stateless_attributes.max_hp = max_hp
	stateless_attributes.max_speed = max_speed
	stateless_attributes.base_damage = base_damage
	stateless_attributes.acceleration = acceleration
	stateless_attributes.friction = friction
	stateless_attributes.steering_force = steering_force
	stateless_attributes.avoid_force = avoid_force
	stateless_attributes.receives_knockback = receives_knockback


var stateful_attributes = {
	"hp": 0,
}

var stateless_attributes = {
	"max_hp": 0,
	"max_speed": 0,
	"base_damage": 0,
	"acceleration": 0,
	"friction": 0.0,
	"agro_radius": 0,
	"steering_force": 0,
	"avoid_force": 0,
	"receives_knockback": true,
}
