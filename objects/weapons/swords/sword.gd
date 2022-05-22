extends Node2D
class_name Sword

onready var animation: AnimationPlayer = $WeaponAnimation
onready var effect: AnimationPlayer = $EffectAnimation
onready var sound: AudioStreamPlayer2D = $SoundEffect
onready var light_cooldown_timer: Timer = $LightCooldown
onready var heavy_cooldown_timer: Timer = $HeavyCooldown
onready var hit_box: WeaponHitbox = $WeaponContainer/WeaponHitbox

export var damage: int
export var holdable_light: bool
export var holdable_heavy: bool
export var chargable_light: bool
export var chargable_heavy: bool
export var heavy_cooldown_time: float = 0
export var light_cooldown_time: float = 0

var character: Character


func _ready() -> void:
	# ! Very dangerous and unsage but i like it :HenryMatsuri:
	# Actually this might be safe
	character = get_node("../../")
	light_cooldown_timer.set_wait_time(light_cooldown_time)
	heavy_cooldown_timer.set_wait_time(heavy_cooldown_time)
	hit_box.damage = damage


# Nullify enemy's projectile if it hits active hitbox
func delete_oncoming_projectile() -> void:
	pass


# TODO: Set input handler so it's not being fucky wucky
func light_attack() -> void:
	if !animation.is_playing() && light_cooldown_timer.is_stopped():
		character.set_is_in_battle(true)
		character.battle_timer.start()
		animation.play("attack")


func light_attack_release() -> void:
	pass


func heavy_attack() -> void:
	if !animation.is_playing() && heavy_cooldown_timer.is_stopped():
		character.set_is_in_battle(true)
		character.battle_timer.start()
		animation.play("spin")
		heavy_cooldown_timer.start()


func heavy_attack_release() -> void:
	pass
