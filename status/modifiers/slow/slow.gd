extends Modifier

export var slow_percentage: float

func modify_stateless(res):
	res["acceleration"] *= slow_percentage / 100
	return res
