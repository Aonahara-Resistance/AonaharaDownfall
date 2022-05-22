extends Modifier

export var extra_hp: int
export var extra_max_hp: int
export var extra_damage: int
export var extra_acceleration: int
export var extra_max_speed: int

var effect = preload("res://entities/characters/nom_nom/skills/get_excited/excited/excited_effect.tscn").instance()


func _ready():
	._ready()
	print("pog/?")
	var effect_container = get_node("../../Vfx")
	effect_container.add_child(effect)


func modify_stateless(res):
	res["acceleration"] += extra_acceleration
	res["max_speed"] += extra_max_speed
	res["max_hp"] += extra_max_hp
	res["base_damage"] += extra_damage
	res["extra_hp"] += extra_hp
	return res


func modify_stateful(_host: Character):
	pass


func _on_Duration_timeout():
	effect.call_deferred("queue_free")
	call_deferred("queue_free")
