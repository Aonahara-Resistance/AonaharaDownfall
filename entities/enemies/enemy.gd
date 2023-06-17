extends KinematicBody2D
class_name Enemy

var attributes
export var effect_hit: PackedScene = preload("res://common/effects/hit_effect.tscn")
export var effect_died: PackedScene = preload("res://common/effects/death_effect/death_effect.tscn")
export var indicator_damage: PackedScene = preload("res://ui/damage_indicator/damage_indicator.tscn")
export var projectile: PackedScene = preload("res://objects/weapons/staves/parseids_staff/rock_shard/rock_shard.tscn")

onready var ai = $Ai
onready var animation: AnimationPlayer = $AnimationPlayer
onready var modifiers: Node2D = $Modifiers
onready var enemy_hitbox: Hitbox = $Hitbox
onready var alert_signal = $Alertsignal
onready var attack_timer: Timer = $AttackTimer
onready var patrol_cooldown_timer: Timer = $PatrolCooldown
onready var health_bar: TextureProgress = $Healthbar
onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
onready var path_timer: Timer = $PathTimer
onready var player_detector: Node2D = $PlayerDetector
onready var range_detector: Node2D = $RangeDetector

signal patrol_finished
signal target_disengaged
signal target_in_range
signal attack_finished
var velocity: Vector2 = Vector2.ZERO
var choosen_direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var spawn_group: String = ""
var is_pouncing: bool = false setget set_is_pouncing
var target = self
var reverse_scan: int = 1
var spawn_location: Vector2 = Vector2.ZERO
var paths: Array = []

export var hp: int
export var max_hp: int
export var max_speed: int
export var base_damage: int
export var acceleration: int
export var receives_knockback: bool
export var avoid_force: float = 1000

export var arrival_radius: int = 50
export var patrol_range: int = 50
export var patrol_cooldown: int = 2
export var sight_range: int = 100
export var attack_radius: int = 20
export var disengage_radius: int = 500

var active_attributes: Dictionary = {
  "hp": 0,
  "max_hp": 0,
  "max_speed": 0,
  "base_damage": 0,
  "acceleration": 0,
  "agro_radius": 0,
  "receives_knockback": true,
}

signal died

## -----------------------------------------------------------------------------
##                                Virtual Methods
## -----------------------------------------------------------------------------


func _ready():

  attributes = EnemeyAttributes.new(
    hp, max_hp, max_speed, base_damage, acceleration, avoid_force, receives_knockback
  )
  enemy_hitbox.set_damage(get_attribute("base_damage"))
  patrol_cooldown_timer.wait_time = patrol_cooldown
  modifier_tick()

  #Setup healthbar
  health_bar.max_value = max_hp
  health_bar.value = hp

  #signas
  GameSignal.connect("party_member_changed", self, "_on_party_member_changed")

  spawn_location = global_position

  for detector in range_detector.get_children():
    detector.cast_to.x = attack_radius

## -----------------------------------------------------------------------------
##                                Movement Stuff
## -----------------------------------------------------------------------------

func chase(delta) -> void:
  var direction = global_position.direction_to(nav_agent.get_next_location())
  var desired_velocipy = direction * acceleration
  var steering = (desired_velocipy - velocity) * delta * 4.0
  velocity += steering
  velocity = move_and_slide(velocity)
  if (target.global_position - global_position).length() > disengage_radius:
    print("huh")
    emit_signal("target_disengaged")

func pounce() -> void:
  yield(get_tree().create_tween().tween_method(self, "set_position", global_position,  target.global_position + Vector2(30,30) * velocity.normalized(), 0.5).set_trans(Tween.TRANS_CIRC),"finished")
  emit_signal("attack_finished")

func set_position(new_position: Vector2):
  move_and_collide(new_position - global_position)


func patrol(delta):
  var steering: Vector2 = Vector2.ZERO

  steering += arrival_steering() * 60 * delta
  velocity += steering * 60 * delta
  velocity = velocity.clamped(get_attribute("max_speed"))
  velocity = move_and_slide(velocity)
  if global_position.floor() == target.global_position.floor():
    emit_signal("patrol_finished")

func direction_to_target():
  if target is Character:
    return global_position.direction_to(target.hurtbox.global_position)
  else:
    return global_position.direction_to(target.global_position)

func arrival_steering() -> Vector2:
  var speed: float = (
    ((global_position - target.global_position).length() / 50)
    * get_attribute("max_speed")
  )
  var desired_velocity: Vector2 = global_position.direction_to(nav_agent.get_next_location()) * speed
  return desired_velocity - velocity

func scan_target():
  player_detector.rotation += 10
  for detector in player_detector.get_children():
    var collider = detector.get_collider()
    if collider is Character:
      if collider.is_in_control == true:
        target = collider
        alert_signal.alert()

func scan_range():
  range_detector.rotation += 10
  for detector in range_detector.get_children():
    var collider = detector.get_collider()
    if collider is Character:
      emit_signal("target_in_range")
  if (target.global_position - global_position).length() > disengage_radius:
    emit_signal("target_disengaged")

func generate_patrol_target() -> Dictionary:
  randomize()
  if spawn_location != Vector2.ZERO:
    return {
      "global_position":
      Vector2(
        spawn_location.x + rand_range(patrol_range * -1, patrol_range), spawn_location.y + rand_range(patrol_range * -1, patrol_range)
      )
    }
  else:
    return {
      "global_position":
      Vector2(
        global_position.x + rand_range(patrol_range * -1, patrol_range), global_position.y + rand_range(patrol_range * -1, patrol_range)
      )
    }

## -----------------------------------------------------------------------------
##                                Combat Stuff
## -----------------------------------------------------------------------------


func listen_knockback(delta) -> void:
  if get_attribute("receives_knockback"):
    knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
    knockback = move_and_slide(knockback)

func apply_knockback(direction, strength) -> void:
  knockback = (direction.direction_to(self.global_position) * strength)

# whatr the fuc kis going on
func _on_Hurtbox_area_entered(hitbox) -> void:
  if hitbox.has_method("get_hitbox_damage"):
    if hitbox.specific_target != null:
      if hitbox.specific_target == self:
        _take_damage(hitbox.get_hitbox_damage())
        ## change way if applying knockback this is deadass weird or maybe not
        apply_knockback(hitbox.global_position, hitbox.knockback_strength)
        Shake.shake(1.0, 0.2, 1)
        spawn_hit_effect()
        spawn_damage_indicator(hitbox.get_hitbox_damage())
        if hitbox.die_after_hit:
          hitbox.die()
    else: 
      _take_damage(hitbox.get_hitbox_damage())
      ## change way if applying knockback this is deadass weird or maybe not
      apply_knockback(hitbox.global_position, hitbox.knockback_strength)
      Shake.shake(1.0, 0.2, 1)
      spawn_hit_effect()
      spawn_damage_indicator(hitbox.get_hitbox_damage())
      if hitbox.die_after_hit:
        hitbox.die()

func _take_damage(damage: int) -> void:
  set_attribute("hp", get_attribute("hp") - damage)
  health_bar.value = get_attribute("hp")
  if get_attribute("hp") < get_attribute("max_hp"):
    health_bar.visible = true
  if get_attribute("hp") <= 0:
    _die()

func _die() -> void:
  emit_signal("died", self)
  if !animation.has_animation("die_right") || !animation.has_animation("die_left"):
    queue_free()
    spawn_death_effect()
    return
  emit_signal("died")

func remove_from_spawn_group():
  if spawn_group != "":
    remove_from_group(spawn_group)

func shoot_projectile(projectile_count: int, circle_size: float) -> void:
  var angle_midpoint = atan2(target.global_position.y - global_position.y, target.global_position.x - global_position.x)
  var start_angle = angle_midpoint - PI * circle_size
  var end_angle = angle_midpoint + PI * circle_size
  for i in range(projectile_count):
      var final_count = projectile_count
      if projectile_count == 1:
        final_count = 2
      var projectile_instance = projectile.instance()
      var angle = lerp(start_angle, end_angle, float(i) / float(final_count - 1))
      var direction = Vector2(cos(angle), sin(angle)) 
      
      projectile_instance.global_position = global_position
      projectile_instance.target = target
      projectile_instance.direction = direction
      get_tree().current_scene.add_child(projectile_instance)

func set_is_pouncing(value):
  if value == false:
    attack_timer.start()
  is_pouncing = value

## -----------------------------------------------------------------------------
##                                Sprites
## -----------------------------------------------------------------------------

func spawn_effect(EFFECT: PackedScene, effect_position: Vector2 = global_position) -> PackedScene:
  var effect = EFFECT.instance()
  get_tree().current_scene.add_child(effect)
  effect.global_position = effect_position
  effect.rotation = randf()
  return effect

func spawn_death_effect() -> void:
  var _hit_effect = spawn_effect(effect_died)

func spawn_hit_effect() -> void:
  var _hit_effect = spawn_effect(effect_hit)

func spawn_damage_indicator(damage: int) -> void:
  var indicator = spawn_effect(indicator_damage)
  if indicator:
    indicator.label.text = str(damage)

## -----------------------------------------------------------------------------
##                                Modifier Stuff
## -----------------------------------------------------------------------------

func get_attribute(attribute: String):
  if active_attributes.has(attribute):
    modifier_tick()
    return active_attributes[attribute]
  else:
    print("Attribute does not exist")
    return 0

func set_attribute(attribute: String, new_value):
  if attributes.stateful_attributes.has(attribute):
    attributes.stateful_attributes[attribute] = new_value
  else:
    attributes.stateless_attributes[attribute] = new_value
  modifier_tick()

func apply_modifier(new_modifier: Modifier) -> void:
  modifiers.add_child(new_modifier)
  modifier_tick()
  new_modifier.modify_stateful(self)

func get_modifiers() -> Array:
  return modifiers.get_children()

func modifier_tick() -> void:
  var res: Dictionary = attributes.stateless_attributes.duplicate()
  var modifier_list: Array = get_modifiers()
  for modifier in modifier_list:
    res = modifier.modify_stateless(res)
  active_attributes = {
    "hp": attributes.stateful_attributes.hp,
    "max_hp": res.max_hp,
    "max_speed": res.max_speed,
    "base_damage": res.base_damage,
    "acceleration": res.acceleration,
    "receives_knockback": res.receives_knockback,
  }

func _on_PathTimer_timeout():
  nav_agent.set_target_location(target.global_position)

func _on_party_member_changed(character):
  if target is Character && target != character:
    target = character
