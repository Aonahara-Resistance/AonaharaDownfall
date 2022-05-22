extends Staff

export var pillar: PackedScene
export var maximum_pillars: int = 2

onready var charge_particle: Particles2D = $WeaponContainer/ChargeParticle
onready var charge_light: Light2D = $WeaponContainer/ChargeLight

var pillars: Array = []


func summon_pillar():
	var active_pillar = pillar.instance()
	pillars.append(active_pillar)
	if pillars.size() > maximum_pillars:
		if is_instance_valid(pillars[0]):
			pillars[0].crumble()
		pillars.remove(0)
	get_tree().current_scene.add_child(active_pillar)
	active_pillar.global_position = get_global_mouse_position()


func heavy_charge():
	if heavy_cooldown_timer.is_stopped():
		charge_particle.set_amount(30)
		charge_light.set_enabled(true)
		heavy_charged = true
