extends Area2D
class_name SingleTarget

export var speed: int = 200
export var damage: int
export var knockback_strength: float
export var homing: bool = false
onready var sprite: Sprite = $Sprite
onready var collision: CollisionShape2D = $CollisionShape2D
onready var hit_box: SingleTargetHitbox = $SingleTargetHitbox
onready var launch_period_timer: Timer = $LaunchPeriod
var direction = Vector2.ZERO
var target

func _process(delta):
  global_position += speed * direction * delta

func _ready():
  hit_box.damage = damage
  hit_box.knockback_strength = knockback_strength
  launch_period_timer.start()

func disable():
  sprite.set_visible(false)
  collision.free()

func launch(character):
  var angle_to_mouse = ((get_global_mouse_position() - character.global_position).normalized()).angle()
  sprite.rotate(angle_to_mouse)

func launch_at_player(character):
  var angle_to_player = ((global_position - character.global_position).normalized()).angle()
  sprite.rotate(angle_to_player)

func _on_LifeTime_timeout():
  disable()

func _on_Lifetime_timeout():
  queue_free()
