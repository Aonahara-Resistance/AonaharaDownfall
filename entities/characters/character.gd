extends KinematicBody2D
class_name Character

onready var animation: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_mode = animation_tree.get("paramaters/playback")

onready var sprite: Sprite = $Sprite

onready var weapon: Node2D = $Weapon
onready var dash: Dash = $Dash
onready var stamina_timer: Timer = $StaminaTimer
onready var camera: Camera2D = $Camera2D
onready var blinker: Blinker = $Blinker
onready var hurtbox: CollisionShape2D = $Hurtbox/CollisionShape2D
onready var sprite_shader_material: ShaderMaterial = sprite.material
onready var battle_timer: Timer = $BattleTimer
onready var interaction_component: InteractionComponent = $InteractionComponent
onready var skills: Node = $Skills
onready var skill_one: Skill = $Skills.get_child(0)
onready var skill_two: Skill = $Skills.get_child(1)
onready var modifiers: Node2D = $Modifiers
onready var state_label: Label = $StateLabel
onready var footstep_timer: Timer = $FootstepTimer
onready var footstep_particle: Particles2D = $FootstepParticle
onready var heavy_cooldown_indicator = $HeavyCooldownI
onready var heavy_cooldown_indicator_timer: Timer = $HeavyCooldownI/FadeoutTimer


export var character_name: String
export var character_icon: Resource
export var mirrored_sprite: bool = true

var is_alive: bool = true
var inf_stamina: bool = false
var inf_health: bool = false
var attributes


export var hp: int
export var stamina: int
export var stamina_regen: float
export var acceleration: int
export var max_hp: int
export var extra_hp: int
export var max_speed: int
export var max_stamina: int
export var base_damage: int
export var stamina_regen_rate: int
export var dash_duration: float
export var dash_cooldown: float
export var dash_speed: int
export var friction: float
export var receives_knockback: bool

export var character_sprite: Texture
export var character_atlas: AtlasTexture

var footstep_sounds: Array = [
  "res://assets/sounds/footsteps/Floor/Steps_floor-001.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-002.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-003.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-004.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-005.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-006.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-007.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-008.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-009.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-010.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-011.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-012.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-013.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-014.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-015.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-016.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-017.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-018.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-019.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-020.ogg",
  "res://assets/sounds/footsteps/Floor/Steps_floor-021.ogg",
]

var active_attributes: Dictionary = {
  "hp": 0,
  "stamina": 0,
  "stamina_regen": 0.0,
  "acceleration": 0,
  "max_hp": 0,
  "max_speed": 0,
  "max_stamina": 0,
  "base_damage": 0,
  "stamina_regen_rate": 0,
  "dash_duration": 0.0,
  "friction": 0.0,
  "receives_knockback": false,
}

var velocity: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var is_in_control: bool = false
var is_focus: bool = false
var is_in_battle: bool = false setget set_is_in_battle, get_is_in_battle
var movement_key: Dictionary = {"up": false, "down": false, "left": false, "right": false}

var footstep_ready = true

signal battle_state_changed

## -----------------------------------------------------------------------------
##                                Virtual Methods
## -----------------------------------------------------------------------------


# get the time and assign to idk the progress bar
# start timer on attack
# send signal
# start cooldown indicator

func _ready() -> void:
  if attributes == null:
    attributes = CharacterAttributes.new(
      hp,
      stamina,
      stamina_regen,
      max_hp,
      extra_hp,
      max_speed,
      max_stamina,
      base_damage,
      acceleration,
      acceleration,
      stamina_regen_rate,
      dash_duration,
      friction,
      receives_knockback
    )
  modifier_tick()

  heavy_cooldown_indicator.max_value = equiped_weapon().heavy_cooldown_time * 60


  _connect_signals()


func _process(delta):
  modifier_tick()

  if velocity.length() > 100:
    footstep_timer.wait_time = 0.29
  if velocity.length() > 200:
    footstep_timer.wait_time = 0.27

  if heavy_cooldown_indicator.value == equiped_weapon().heavy_cooldown_time * 60:
    heavy_cooldown_indicator.material.set_shader_param("shine_progress", heavy_cooldown_indicator.material.get_shader_param("shine_progress") + 0.1)

  heavy_cooldown_indicator.value += 1 * delta * 60

## -----------------------------------------------------------------------------
##                                Input Listeners
## -----------------------------------------------------------------------------

func listen_to_input_direction(event) -> void:

  if event.is_action_pressed("up"):
    movement_key["up"] = true
  if event.is_action_pressed("down"):
    movement_key["down"] = true
  if event.is_action_pressed("left"):
    movement_key["left"] = true
  if event.is_action_pressed("right"):
    movement_key["right"] = true
  if event.is_action_released("up"):
    movement_key["up"] = false
  if event.is_action_released("down"):
    movement_key["down"] = false
  if event.is_action_released("left"):
    movement_key["left"] = false
  if event.is_action_released("right"):
    movement_key["right"] = false

func listen_to_attacks(event) -> void:
  if event.is_action_pressed("light_attack"):
    equiped_weapon().light_attack()
  if event.is_action_released("light_attack"):
    equiped_weapon().light_attack_release()
  if event.is_action_pressed("heavy_attack"):
    equiped_weapon().heavy_attack()
  if event.is_action_released("heavy_attack"):
    equiped_weapon().heavy_attack_release()

func listen_to_focus_mode(event) -> void:
  if event.is_action_pressed("focus"):
    is_focus = true
  if event.is_action_released("focus"):
    is_focus = false

func listen_to_skills(event) -> void:
  if event.is_action_pressed("first_skill"):
    skill_one.activate_skill()
  if event.is_action_pressed("second_skill"):
    skill_two.activate_skill()

func listen_to_party_change(event) -> void:
  if event.is_action_pressed("party1") && is_in_control:
    GameSignal.emit_signal("party_member_change_requested", 0)
  if event.is_action_pressed("party2") && is_in_control:
    GameSignal.emit_signal("party_member_change_requested", 1)
  if event.is_action_pressed("party3") && is_in_control:
    GameSignal.emit_signal("party_member_change_requested", 2)

func listen_to_dash(event) -> void:
  if event.is_action_pressed("dash") && is_in_control:
    dash.start_dash(self)
    set_stamina_regen_timer(get_attribute("stamina"))
    stamina_timer.start()

## -----------------------------------------------------------------------------
##                                Movement Stuff
## -----------------------------------------------------------------------------

func move(delta: float) -> void:
  # Footstep audio
  if velocity.length() > 10 && footstep_ready:
    randomize()
    var file = File.new()
    file.open(footstep_sounds[randi() % 20 + 1], File.READ)
    var buffer = file.get_buffer(file.get_len())
    var stream = AudioStreamOGGVorbis.new()
    stream.data = buffer
    var sfx = AudioStreamPlayer.new()
    sfx.volume_db = -40
    sfx.stream = stream
    sfx.connect("finished", sfx, "queue_free")
    get_tree().root.add_child(sfx) 
    sfx.play()
    footstep_ready = false
    footstep_timer.start()

  #Footstep Particle
  if velocity.length() > 10:
    footstep_particle.emitting = true
  else:
    footstep_particle.emitting = false

  var input_direction: Vector2 = get_input_direction()
  velocity = move_and_slide(velocity)
  velocity += (get_attribute("acceleration") * input_direction * delta * 60)
  velocity = lerp(velocity, Vector2.ZERO, get_attribute("friction"))
  velocity = velocity.clamped(get_attribute("max_speed"))

func _on_Dash_started() -> void:
  _whiten_sprite(dash_duration)
  _enable_iframes(dash_duration)

## -----------------------------------------------------------------------------
##                                Combat Stuff
## -----------------------------------------------------------------------------

func equiped_weapon():
  if !weapon.get_children().empty():
    return weapon.get_child(0)
  else:
    # TDOO: Handle if weapon is not equiped
    return null

func get_is_in_battle() -> bool:
  return is_in_battle

func set_is_in_battle(new_state) -> void:
  if new_state == true:
    battle_timer.start()
  is_in_battle = new_state
  emit_signal("battle_state_changed")

func listen_knockback(delta) -> void:
  if get_attribute("receives_knockback"):
    knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
    knockback = move_and_slide(knockback)

func apply_knockback(direction, strength) -> void:
  knockback = (direction.direction_to(self.global_position) * strength)

func _on_Hurtbox_area_entered(hitbox) -> void:
  if hitbox.has_method("get_hitbox_damage"):
    _take_damage(hitbox.get_hitbox_damage())
    blinker.start_blinking(sprite)
    _whiten_sprite(0.3)
    Shake.shake(1.0, 0.2, 1)

  # idk what is this  but it doesn't work because i coded it like 2 yeas ago
  #print(hitbox)
  #if hitbox is WeaponHitbox:
  #  print("here")
  #  set_is_in_battle(false)
  #  blinker.start_blinking(sprite)
  #  _whiten_sprite(0.3)
  #  _take_damage(hitbox.damage)
  #  apply_knockback(hitbox.global_position, hitbox.knockback_strength)
  #  _enable_iframes(1.0)

func regenerate_stamina() -> void:
  while get_attribute("stamina") < get_attribute("max_stamina") && stamina_timer.is_stopped():
    set_attribute("stamina", get_attribute("stamina") + 1)
    GameSignal.emit_signal("stamina_changed", self)
    yield(get_tree().create_timer(get_attribute("stamina_regen_rate")), "timeout")

func get_stamina_timer() -> float:
  return stamina_timer.time_left

func _on_StaminaTimer_timeout() -> void:
  regenerate_stamina()

func set_stamina_regen_timer(current_stamina) -> void:
  if current_stamina == 0:
    stamina_timer.wait_time = get_attribute("stamina_regen") * 2
  else:
    stamina_timer.wait_time = get_attribute("stamina_regen")

func _take_damage(damage: int) -> void:
  if inf_health:
    set_attribute("hp", get_attribute("hp") - damage * 0)
  else:
    set_attribute("hp", get_attribute("hp") - damage)
  if get_attribute("hp") < 0:
    set_attribute("hp", 0)
  _die_check(get_attribute("hp"))
  GameSignal.emit_signal("health_changed", self)

func _enable_iframes(duration: float) -> void:
  hurtbox.set_deferred("disabled", true)
  yield(get_tree().create_timer(duration), "timeout")
  hurtbox.disabled = false

func _die_check(current_hp: int) -> void:
  if current_hp <= 0:
    die()

func die() -> void:
  is_alive = false
  GameSignal.emit_signal("party_member_died")

func reset_stats() -> void:
  set_attribute("hp", attributes.stateless_attributes.max_hp)
  set_attribute("stamina", attributes.stateless_attributes.max_stamina)
  GameSignal.emit_signal("health_changed", self)
  GameSignal.emit_signal("stamina_changed", self)

func _on_BattleTimer_timeout():
  set_is_in_battle(false)

## -----------------------------------------------------------------------------
##                              Modifier Stuff
## -----------------------------------------------------------------------------

func get_attribute(attribute: String):
  if active_attributes.has(attribute):
    modifier_tick()
    return active_attributes[attribute]
  else:
    print("Attribute does not exist")
    print(attribute)
    return 0

func set_attribute(attribute: String, new_value):
  if attributes.stateful_attributes.has(attribute):
    attributes.stateful_attributes[attribute] = new_value
  else:
    attributes.stateless_attributes[attribute] = new_value
  modifier_tick()

func apply_modifier(new_modifier: Modifier) -> void:
  var modifier_list: Array = get_modifiers()
  for modifier in modifier_list:
    if modifier.buff_name == new_modifier.buff_name:
      modifier.reset_duration()
      return
  new_modifier.connect("modifier_ended", self, "_on_modifier_ended")
  modifiers.add_child(new_modifier)
  modifier_tick()
  new_modifier.modify_stateful(self)
  GameSignal.emit_signal("modifier_applied", self)

func reset_modifier() -> void:
  var modifier_list: Array = get_modifiers()
  for modifier in modifier_list:
    modifier.get_parent().remove_child(modifier)
  GameSignal.emit_signal("modifier_reset", self)

func get_modifiers() -> Array:
  return modifiers.get_children()

func modifier_tick() -> void:
  var res: Dictionary = attributes.stateless_attributes.duplicate()
  var modifier_list: Array = get_modifiers()
  for modifier in modifier_list:
    if modifier.is_active:
      res = modifier.modify_stateless(res)
  active_attributes = {
    "hp": attributes.stateful_attributes.hp + res.extra_hp,
    "stamina": attributes.stateful_attributes.stamina,
    "stamina_regen": res.stamina_regen,
    "acceleration": res.acceleration,
    "max_hp": res.max_hp,
    "max_speed": res.max_speed,
    "max_stamina": res.max_stamina,
    "base_damage": res.base_damage,
    "stamina_regen_rate": res.stamina_regen_rate,
    "dash_duration": res.dash_duration,
    "friction": res.friction,
    "receives_knockback": res.receives_knockback,
  }
  GameSignal.emit_signal("modifier_ticked")

## -----------------------------------------------------------------------------
##                                  Miscs
## -----------------------------------------------------------------------------

func get_mouse_direction() -> Vector2:
  return (get_global_mouse_position() - global_position).normalized()

func get_input_direction() -> Vector2:
  var input_direction: Vector2 = Vector2.ZERO
  input_direction.x = (int(movement_key["right"]) - int(movement_key["left"]))
  input_direction.y = (int(movement_key["down"]) - int(movement_key["up"]))
  input_direction = input_direction.normalized()
  if is_in_control:
    return input_direction
  else:
    return Vector2.ZERO

func sprite_control() -> void:
  var mouse_direction: Vector2 = get_mouse_direction()
  _flip_interaction_detection(mouse_direction)
  _control_weapon_direction(mouse_direction)
  _flip_character_sprite(mouse_direction)

func _flip_interaction_detection(mouse_direction):
  if mouse_direction.x < 0 and sign(interaction_component.scale.x) != sign(mouse_direction.x):
    interaction_component.scale.x *= -1
  elif mouse_direction.x > 0 and sign(interaction_component.scale.x) != sign(mouse_direction.x):
    interaction_component.scale.x *= -1

func _flip_character_sprite(mouse_direction):
  if mirrored_sprite:
    if mouse_direction.x < 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
      sprite.scale.x *= -1
    elif mouse_direction.x > 0 and sign(sprite.scale.x) != sign(mouse_direction.x):
      sprite.scale.x *= -1

func _control_weapon_direction(mouse_direction):
  weapon.rotation = mouse_direction.angle()
  if mouse_direction.x < 0 and sign(weapon.scale.y) != sign(mouse_direction.x):
    weapon.scale.y *= -1
  elif mouse_direction.x > 0 and sign(weapon.scale.y) != sign(mouse_direction.x):
    weapon.scale.y *= -1
  if mouse_direction.y < 0 and sign(weapon.z_index) != sign(mouse_direction.y):
    weapon.z_index *= -1
  elif mouse_direction.y > 0 and sign(weapon.z_index) != sign(mouse_direction.y):
    weapon.z_index *= -1

func _whiten_sprite(duration: float):
  sprite_shader_material.set_shader_param("whiten", true)
  yield(get_tree().create_timer(duration), "timeout")
  sprite_shader_material.set_shader_param("whiten", false)

# warning-ignore-all:return_value_discarded
func _connect_signals():
  dash.connect("dash_started", self, "_on_Dash_started")
  equiped_weapon().connect("heavy_attack_released", self, "_on_heavy_attack_released")

func _on_heavy_attack_released():
  heavy_cooldown_indicator.value = 0
  heavy_cooldown_indicator.visible = true
  get_tree().create_tween().tween_property(heavy_cooldown_indicator, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_SINE)
  if !heavy_cooldown_indicator_timer.is_stopped():
    heavy_cooldown_indicator_timer.stop()


func _on_FootstepTimer_timeout():
  footstep_ready = true


func _on_HeavyCooldownI_value_changed(value:float) -> void:
  if value == equiped_weapon().heavy_cooldown_time * 60:
    heavy_cooldown_indicator.material.set_shader_param("shine_progress", 0)
    heavy_cooldown_indicator_timer.start()

func _on_modifier_ended() -> void:
  modifier_tick()
  GameSignal.emit_signal("modifier_ended", self)

func _on_FadeoutTimer_timeout():
  get_tree().create_tween().tween_property(heavy_cooldown_indicator, "modulate", Color.transparent, 0.5).set_trans(Tween.TRANS_SINE)


