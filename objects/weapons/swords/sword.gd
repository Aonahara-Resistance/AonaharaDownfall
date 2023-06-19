extends Node2D
class_name Sword

onready var animation: AnimationPlayer = $WeaponAnimation
onready var effect: AnimationPlayer = $EffectAnimation
onready var sound: AudioStreamPlayer2D = $SoundEffect
onready var light_cooldown_timer: Timer = $LightCooldown
onready var heavy_cooldown_timer: Timer = $HeavyCooldown
onready var hit_box: WeaponHitbox = $WeaponContainer/WeaponHitbox
onready var sprite: Sprite = $WeaponContainer/Sprite

export var damage: int
export var holdable_light: bool
export var holdable_heavy: bool
export var chargable_light: bool
export var chargable_heavy: bool
export var heavy_cooldown_time: float
export var light_cooldown_time: float

var character: Character

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

func delete_oncoming_projectile(projectile) -> void:
  projectile.queue_free()


# TODO: Set input handler so it's not being fucky wucky
func light_attack() -> void:
  if !animation.is_playing() && light_cooldown_timer.is_stopped():
    character.set_is_in_battle(true)
    character.battle_timer.start()
    #??? wtf
    animation.play("attack")


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

