extends KinematicBody2D
class_name Family

export var damage: int
export var speed: int = 200
export var drag: float = 0.5

onready var hitbox: WeaponHitbox = $WeaponHitbox
onready var hitbox_collision: CollisionShape2D = $WeaponHitbox/CollisionShape2D
onready var sprite: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer2

var current_velocity: Vector2 = Vector2.ZERO

var target: Enemy

func die():
  hitbox_collision.call_deferred("set_disabled", true)
  animation.play("die")

func _on_enemy_died(enemy):
  if target == enemy:
    target = null

func _ready() -> void:
  randomize()
  var i
  hitbox.damage = damage
  i = randi() % 4 + 1 
  if i == 1:
    current_velocity = speed * Vector2.RIGHT.rotated(rotation) * 0.5
  elif i  == 2:
    current_velocity = speed * Vector2.LEFT.rotated(rotation) * 0.5
  elif i  == 3:
    current_velocity = speed * Vector2.UP.rotated(rotation) * 0.5
  elif i  == 4:
    current_velocity = speed * Vector2.DOWN.rotated(rotation) * 0.5

func _process(delta):
  var direction: Vector2 = Vector2.RIGHT.rotated(rotation).normalized()
  if target:
    direction = global_position.direction_to(target.global_position)
    if (target.global_position - global_position).x < 0 and sign(sprite.scale.x) != sign((target.global_position - global_position).x):
      sprite.scale.x *= -1
    elif (target.global_position - global_position).x > 0 and sign(sprite.scale.x) != sign((target.global_position - global_position).x):
      sprite.scale.x *= -1
  else:
    die()
  var desired_velocity = direction * speed
  var change = (desired_velocity - current_velocity) * drag
  current_velocity += change * delta
  global_position += current_velocity * delta
  
