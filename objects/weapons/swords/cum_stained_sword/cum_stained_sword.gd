extends Sword
class_name CumStainedSword
export var cum_projectile: PackedScene

var cum_charge: int
var cum_threshold: int = 5

func delete_oncoming_projectile(projectile) -> void:
  .delete_oncoming_projectile(projectile)
  cum_charge += 1
  if cum_charge == cum_threshold:
    var shader: ShaderMaterial = sprite.material
    shader.set_shader_param("intensity", 30)
    
func light_attack() -> void:
  .light_attack()
  if cum_charge == cum_threshold:
    release_cum()
    cum_charge = 0

func release_cum() -> void:
  var active_projectile = cum_projectile.instance()
  get_tree().current_scene.add_child(active_projectile)
  active_projectile.direction = character.get_mouse_direction()
  active_projectile.global_position = self.global_position
  
  var shader: ShaderMaterial = sprite.material
  shader.set_shader_param("intensity", 0)

