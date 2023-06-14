extends Node
class_name Blinker

var is_visible: bool = true
var blink_object: Node2D

onready var blink_timer: Timer = $BlinkTimer
onready var duration_timer: Timer = $DurationTimer

export(float) var duration: float
export(float) var blink_interval: float

func _ready() -> void:
  duration_timer.set_wait_time(duration)
  blink_timer.set_wait_time(blink_interval)

func start_blinking(new_blink_object: Node2D) -> void:
  blink_object = new_blink_object
  duration_timer.start()
  blink_timer.start()

func blink() -> void:
  if is_visible:
    set_visible(false)
  else:
    set_visible(true)
  is_visible = !is_visible

func set_visible(isVisible: bool) -> void:
  if isVisible:
    blink_object.modulate.a = 1
  else:
    blink_object.modulate.a = 0

func _on_BlinkTimer_timeout() -> void:
  blink()

func _on_DurationTimer_timeout() -> void:
  set_visible(true)
  blink_timer.stop()
