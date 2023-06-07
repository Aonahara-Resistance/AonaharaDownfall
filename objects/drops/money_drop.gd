extends Area2D

onready var sound: AudioStreamPlayer2D = $Sound
onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D

var money_value: int
var homing: bool = false
var target


func _physics_process(delta):
  if homing:
    var distance = global_position.distance_to(target.global_position)
    if distance > 10:
        var direction = (target.global_position - global_position).normalized()
        var velocity = direction * 100
        global_position += velocity * delta
    pass
    

func _on_MoneyDrop_area_entered(area:Area2D):
  if area.name == "MoneyMagnet":
    homing = true
    target = area
  if area.name == "MoneyPickup":
    # Pick up things
    GameSignal.emit_signal("money_picked_up", money_value)
    sprite.visible = false
    collision_shape.set_deferred("disabled", true)
    sound.play()

func get_money_value() -> int:
  return money_value

func _on_Sound_finished():
  queue_free()

