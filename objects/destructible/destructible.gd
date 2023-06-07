extends Area2D
class_name Destructible

onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var audio: AudioStreamPlayer2D = $Sound

export var effect_destroyed: PackedScene = preload("res://common/effects/death_effect/death_effect.tscn")

func _on_Destructible_area_entered(area:Area2D):
  if area.has_method("get_hitbox_damage"):
    audio.play()
    var effect = effect_destroyed.instance()
    get_tree().current_scene.add_child(effect)
    effect.global_position = self.global_position
    effect.rotation = randf()
    sprite.visible = false
    collision_shape.call_deferred("set_disabled", true)
    Shake.shake(0.2, 0.2, 1)


func _on_Sound_finished():
  queue_free()

