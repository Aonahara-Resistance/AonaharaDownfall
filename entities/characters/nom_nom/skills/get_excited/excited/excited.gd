extends Modifier

export var extra_hp: int
export var extra_max_hp: int
export var extra_damage: int
export var extra_acceleration: int
export var extra_max_speed: int

func modify_stateless(res):
	res["acceleration"] += extra_acceleration
	res["max_speed"] += extra_max_speed
	res["max_hp"] += extra_max_hp
	res["base_damage"] += extra_damage
	return res

func modify_stateful(host):
	host.set_attribute("hp", int(min(host.get_attribute("hp") + extra_hp, host.get_attribute("max_hp"))))
	GameSignal.emit_signal("health_changed", host)


