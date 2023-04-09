extends Resource
class_name CharacterAttributes

var stateful_attributes = {
	"hp": 0,
	"stamina": 0,
}

var stateless_attributes = {
	"stamina_regen": 0.0,
	"acceleration": 0,
	"base_acceleration": 0,
	"max_hp": 0,
	"extra_hp": 0,
	"max_speed": 0,
	"max_stamina": 0,
	"base_damage": 0,
	"stamina_regen_rate": 0,
	"dash_duration": 0.0,
	"friction": 0.0,
	"receives_knockback": false,
}

func _init(
	hp: int,
	stamina: int,
	stamina_regen: float,
	max_hp: int,
	extra_hp: int,
	max_speed: int,
	max_stamina: int,
	base_damage: int,
	acceleration: int,
	base_acceleration: int,
	stamina_regen_rate: int,
	dash_duration: float,
	friction: float,
	receives_knockback: bool
):
	stateful_attributes.hp = hp
	stateful_attributes.stamina = stamina
	stateless_attributes.stamina_regen = stamina_regen
	stateless_attributes.acceleration = acceleration
	stateless_attributes.base_acceleration = base_acceleration
	stateless_attributes.max_hp = max_hp
	stateless_attributes.extra_hp = extra_hp
	stateless_attributes.max_speed = max_speed
	stateless_attributes.max_stamina = max_stamina
	stateless_attributes.base_damage = base_damage
	stateless_attributes.stamina_regen_rate = stamina_regen_rate
	stateless_attributes.dash_duration = dash_duration
	stateless_attributes.friction = friction
	stateless_attributes.receives_knockback = receives_knockback
