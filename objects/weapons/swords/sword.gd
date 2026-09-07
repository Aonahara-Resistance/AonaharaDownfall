extends Node2D
class_name Sword

onready var animation: AnimationPlayer = $WeaponAnimation
onready var effect: AnimationPlayer = $EffectAnimation
onready var sound: AudioStreamPlayer2D = $SoundEffect
onready var light_cooldown_timer: Timer = $LightCooldown
onready var heavy_cooldown_timer: Timer = $HeavyCooldown
onready var hit_box: WeaponHitbox = $WeaponContainer/WeaponHitbox
onready var sprite: Sprite = $WeaponContainer/Sprite
onready var container: Node2D = $WeaponContainer

export var damage: int
export var holdable_light: bool
export var holdable_heavy: bool
export var chargable_light: bool
export var chargable_heavy: bool
export var heavy_cooldown_time: float
export var light_cooldown_time: float

var character: Character

# Feel tuning. commit_time is how long the swing is uncancelable; after it the
# pose is held and the next attack can cut straight in. Dash always cancels.
export var commit_time: float = 0.18
export var combo_reset_time: float = 0.6
export var lunge_strength: float = 260.0        # the thrust finisher
export var swing_lunge_strength: float = 150.0  # hits 1 and 2
export var body_tilt_degrees: float = 8.0
export var rest_return_time: float = 0.16

const COMBO := ["attack", "attack_back", "attack_thrust"]
var _buffered: bool = false
var _combo_step: int = 0
var _combo_expires: int = 0
var _rest_rotation: float
var _rest_position: Vector2
var _rest_tween: SceneTreeTween

signal heavy_attack_released

func _ready() -> void:
  # ! Very dangerous and unsage but i like it :HenryMatsuri:
  # Actually this might be safe
  character = get_node("../../")
  if light_cooldown_time != 0:
    light_cooldown_timer.set_wait_time(light_cooldown_time)
  if heavy_cooldown_time != 0:
    heavy_cooldown_timer.set_wait_time(heavy_cooldown_time)
  hit_box.set_damage(damage)
  #???? wtf
  animation.connect("animation_finished", self, "_on_swing_finished")
  _rest_rotation = container.rotation_degrees
  _rest_position = container.position

func delete_oncoming_projectile(projectile) -> void:
  projectile.queue_free()


func light_attack() -> void:
  if !is_swinging():
    _swing()
  elif animation.current_animation_position < commit_time:
    _buffered = true    # inside the commit: queue, do not drop
  else:
    _swing()            # past the commit: cut the hold short, chain now


func is_swinging() -> bool:
  return animation.is_playing() && animation.current_animation in COMBO


# Movement is locked for as long as this is true. Stateless on purpose, so a
# cancelled or interrupted swing can never leave the character stuck.
func is_committing() -> bool:
  return is_swinging()


# Override this, not light_attack(), so subclass effects only fire on a swing
# that actually happened.
func _swing() -> void:
  _buffered = false
  if _rest_tween != null && _rest_tween.is_valid():
    _rest_tween.kill()
  if OS.get_ticks_msec() > _combo_expires:
    _combo_step = 0
  var anim: String = COMBO[_combo_step]
  _combo_step = (_combo_step + 1) % COMBO.size()
  _combo_expires = OS.get_ticks_msec() + int(combo_reset_time * 1000)
  character.set_is_in_battle(true)
  character.battle_timer.start()
  if sound.stream != null:
    sound.pitch_scale = rand_range(0.92, 1.09)
    sound.play()
  # Every swing carries you forward a little; the finisher carries you a lot.
  if character.has_method("apply_lunge"):
    var strength: float = lunge_strength if anim == "attack_thrust" else swing_lunge_strength
    character.apply_lunge(character.get_mouse_direction(), strength)
  if character.has_method("tilt_body"):
    var tilt: float = body_tilt_degrees
    if anim == "attack_back":
      tilt = -body_tilt_degrees
    elif anim == "attack_thrust":
      tilt = body_tilt_degrees * 0.4
    character.tilt_body(tilt)
  animation.play(anim)


func _on_swing_finished(anim_name: String) -> void:
  if !(anim_name in COMBO):
    return
  if _buffered:
    _swing()
  else:
    _return_to_rest()


# The swings deliberately hold their finishing pose so the next one can cut in.
# If none does, ease back to the pose captured at _ready instead of hanging there.
func _return_to_rest() -> void:
  if _rest_tween != null && _rest_tween.is_valid():
    _rest_tween.kill()
  _rest_tween = get_tree().create_tween().set_parallel(true)
  _rest_tween.tween_property(container, "rotation_degrees", _rest_rotation, rest_return_time)
  _rest_tween.tween_property(container, "position", _rest_position, rest_return_time)


func cancel_attack() -> void:
  _buffered = false
  if is_swinging():
    animation.stop()
    _return_to_rest()
  if character.has_method("tilt_body"):
    character.tilt_body(0.0)


func light_attack_release() -> void:
  pass


func heavy_attack() -> void:
  if !animation.is_playing() && heavy_cooldown_timer.is_stopped():
    emit_signal("heavy_attack_released")
    character.set_is_in_battle(true)
    character.battle_timer.start()
    animation.play("spin")
    heavy_cooldown_timer.start()


func heavy_attack_release() -> void:
  pass

func _on_WeaponHitbox_area_entered(area:Area2D):
  if area.has_method("launch_at_player"):
    delete_oncoming_projectile(area)
  print(area)

