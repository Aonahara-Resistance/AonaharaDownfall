extends Staff

export var pillar: PackedScene
export var maximum_pillars: int = 2

onready var charge_particle: Particles2D = $WeaponContainer/ChargeParticle
onready var charge_light: Light2D = $WeaponContainer/ChargeLight
onready var weapon_container: Node2D =  $WeaponContainer 


var pillars: Array = []
var staff_shake = 0


func _process(_delta):
  if charge_particle.emitting:
    shake_staff(2)
  else:
    stop_shaking()
  

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

func shake_staff(shake_intensity) -> void:
  staff_shake = shake_intensity
  weapon_container.position = Vector2(randf(), randf()) * shake_intensity

func stop_shaking() -> void:
  var new_shake = lerp(staff_shake, 0, 0.1)
  staff_shake = new_shake
