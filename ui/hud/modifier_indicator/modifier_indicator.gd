extends TextureRect
class_name ModifierIndicator

onready var cooldown_progress: TextureProgress = $CooldownIndicator

func _process(delta) -> void:
  process_cooldown(delta)

func process_cooldown(delta) -> void:
  cooldown_progress.value += 60 * delta

func _on_CooldownIndicator_value_changed(value: float):
  if cooldown_progress.max_value == value:
    queue_free()
