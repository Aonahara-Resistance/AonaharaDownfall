extends Modifier

onready var attack_interval_timer: Timer = $AttackIntervalTimer
var enemies = []

onready var wife = preload("res://entities/characters/nom_nom/skills/scrilspeokr/family/wife.tscn")
onready var daugther_one = preload("res://entities/characters/nom_nom/skills/scrilspeokr/family/daugther_one.tscn")
onready var daugther_two = preload("res://entities/characters/nom_nom/skills/scrilspeokr/family/daugther_two.tscn")
onready var daugther_three = preload("res://entities/characters/nom_nom/skills/scrilspeokr/family/daugther_tree.tscn")

func _ready():
  attack_interval_timer.start()

func spawn_thing(thing, target: Enemy, damage) -> void:
  var instance: Family = thing.instance()
  var instance_hitbox: WeaponHitbox = instance.get_node("WeaponHitbox")
  # dangerous but fuck it
  var character: Character = get_node("../..")
  instance.damage = damage
  instance.target = target
  target.connect("died", instance, "_on_enemy_died")
  instance_hitbox.specific_target = target
  instance_hitbox.die_after_hit = true
  instance.global_position = character.global_position
  var level = get_tree().get_current_scene() as Level 
  level.ysort.add_child(instance)

func _on_Area2D_body_exited(body:Node):
  if body is Enemy:
    enemies.erase(body)

func _on_Area2D_body_entered(body:Node):
  if body is Enemy:
    enemies.append(body)
    body.connect("died", self, "_on_enemy_died")

func _on_enemy_died(enemy):
  if enemies.has(enemy):
    enemies.erase(enemy)


# This is an asbolute shit of code but it works fuck
func _on_AttackIntervalTimer_timeout():
  if enemies.size() == 0:
    return
  if enemies.size() == 1:
    var target = enemies[0]
    spawn_thing(wife, target, target.max_hp * 0.0125)
    spawn_thing(daugther_one, target, target.max_hp * 0.0125)
    spawn_thing(daugther_two, target, target.max_hp * 0.0125)
    spawn_thing(daugther_three, target, target.max_hp * 0.0125)
  elif enemies.size() == 2:
    var target = enemies[0]
    var target2 = enemies[1]
    spawn_thing(wife, target, target.max_hp * 0.02)
    spawn_thing(daugther_one, target2, 30)
    spawn_thing(daugther_two, target2, 30)
    spawn_thing(daugther_three, target2, 30)
  elif enemies.size() == 3:
    var target = enemies[0]
    var target2 = enemies[1]
    var target3 = enemies[2]
    spawn_thing(wife, target, target.max_hp * 0.02)
    spawn_thing(daugther_one, target2, 30)
    spawn_thing(daugther_two, target3, 30)
    spawn_thing(daugther_three, target3, 30)
  elif enemies.size() >= 4:
    var target = enemies[0]
    var target2 = enemies[1]
    var target3 = enemies[2]
    var target4 = enemies[3]
    spawn_thing(wife, target, target.max_hp * 0.02)
    spawn_thing(daugther_one, target2, 30)
    spawn_thing(daugther_two, target3, 30)
    spawn_thing(daugther_three, target4, 30)
