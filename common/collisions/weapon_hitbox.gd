extends Area2D
class_name WeaponHitbox

export var parent_path:NodePath

onready var parent = get_node(parent_path)

var damage: int = 0 setget set_damage
var character_damage: int = 0 setget set_character_damage
var knockback_strength: float
var specific_target: Node2D
var die_after_hit: bool = false

func _ready() -> void:
  randomize()
  knockback_strength = 0

func die() -> void:
  if parent.has_method("die"):
    parent.die()
  else:
    print("parent cannot die")

func set_damage(new_damage: int) -> void:
  if new_damage > 0:
    damage = new_damage
  else:
    damage = 0

func set_character_damage(new_character_damage: int) -> void:
  if new_character_damage > 0:
    character_damage = new_character_damage
  else:
    character_damage = 0

func total_damage() -> int:
    return get_randomized_hitbox_damage()

func get_hitbox_damage() -> int:
  return damage + character_damage

func get_randomized_hitbox_damage() -> int:
  return randomize_damage(damage + character_damage)

func randomize_damage(input_damage: int) -> int:
  return int(round(rand_range(input_damage * 0.9, input_damage * 1.2)))
