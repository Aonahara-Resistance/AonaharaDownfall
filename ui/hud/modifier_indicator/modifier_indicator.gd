extends TextureRect
class_name ModifierIndicator

# Set by Hud.update_modifier_indicator. The modifier's own Duration timer is the
# only clock here, so the fill can't drift from the buff or care about fps.
var duration_timer: Timer

onready var cooldown_progress: TextureProgress = $CooldownIndicator

func _process(_delta) -> void:
  if !is_instance_valid(duration_timer) || duration_timer.is_stopped():
    queue_free()
    return
  cooldown_progress.value = cooldown_progress.max_value * (
    1.0 - duration_timer.time_left / duration_timer.wait_time
  )
