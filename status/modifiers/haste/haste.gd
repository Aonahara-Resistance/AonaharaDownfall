extends Modifier

export var extra_acceleration: int
export var extra_max_speed: int

func modify_stateless(res):
	res["acceleration"] += extra_acceleration
	res["max_speed"] += extra_max_speed
	res["extra_hp"] += 1
	return res
