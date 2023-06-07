extends Area2D
class_name Destructible

onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var audio: AudioStreamPlayer2D = $Sound

export var money_drop: PackedScene = preload("res://objects/drops/money_drop.tscn")
export var money_drop_start: int
export var money_drop_end: int
export var money_value: int = 0

export var effect_destroyed: PackedScene = preload("res://common/effects/death_effect/death_effect.tscn")

var money_sounds = [
  load("res://objects/drops/coin_1.wav"),
  load("res://objects/drops/coin_2.wav"),
  load("res://objects/drops/coin_3.wav"),
  load("res://objects/drops/coin_4.wav"),
  load("res://objects/drops/coin_5.wav"),
  load("res://objects/drops/coin_6.wav"),
  load("res://objects/drops/coin_7.wav"),
  load("res://objects/drops/coin_8.wav"),
  load("res://objects/drops/coin_9.wav"),
  load("res://objects/drops/coin_10.wav"),
]

func _on_Destructible_area_entered(area:Area2D):
  randomize()
  if area.has_method("get_hitbox_damage"):
    # Destroyed
    audio.play()
    var effect = effect_destroyed.instance()
    get_tree().current_scene.add_child(effect)
    effect.global_position = self.global_position
    effect.rotation = randf()
    sprite.visible = false
    collision_shape.set_deferred("disabled", true)
    Shake.shake(0.2, 0.2, 1)

    # Play random audio

    # Drop Money
    var dropped_count = randi() % money_drop_end + money_drop_start
    for _i in range(dropped_count):
      var instance = money_drop.instance()
      var level = get_tree().get_current_scene() as Level 
      instance.money_value = money_value
      level.ysort.add_child(instance)
      instance.global_position = global_position
      get_tree().create_tween().tween_property(instance, "global_position", Vector2(global_position.x + rand_range(-30,30), global_position.y + rand_range(-30,30)), 0.2).set_trans(Tween.TRANS_BACK)

      var sfx = AudioStreamPlayer2D.new()
      sfx.stream = money_sounds[0]
      sfx.connect("finished", sfx, "queue_free")
      sfx.global_position = global_position
      sfx.autoplay = false
      get_tree().root.add_child(sfx) 
      sfx.play()

func _on_Sound_finished():
  queue_free()

