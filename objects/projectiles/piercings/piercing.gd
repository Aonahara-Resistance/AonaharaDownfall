extends Area2D
class_name Piercing

export var speed: int = 200
export var damage: int
export var knockback_strength: float
var direction = Vector2.ZERO
onready var sprite: Sprite = $Sprite
onready var collision: CollisionShape2D = $CollisionShape2D
onready var hit_box: PiercingHitbox = $PiercingHitbox

func _process(delta):
  global_position += speed * direction * delta

func _ready():
  hit_box.damage = damage
  hit_box.knockback_strength = knockback_strength

func disable():
  sprite.set_visible(false)
  collision.free()

func launch(character):
  var angle_to_mouse = ((get_global_mouse_position() - character.global_position).normalized()).angle()
  sprite.rotate(angle_to_mouse)

func _on_LifeTime_timeout():
  disable()

func _on_Lifetime_timeout():
  queue_free()


func _on_Piercing_body_entered(body:Node):
  # TODO: Add breaking animation
  if body is TileMap:
    disable()
    queue_free()

