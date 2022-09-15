extends Node
class_name Blinker

var _is_visible: bool = true
var _blink_object: Node2D

onready var _blink_timer: Timer = $BlinkTimer
onready var _duration_timer: Timer = $DurationTimer

export(float) var duration: float
export(float) var blink_interval: float


func _ready() -> void:
	_duration_timer.set_wait_time(duration)
	_blink_timer.set_wait_time(blink_interval)


func start_blinking(blink_object: Node2D) -> void:
	_blink_object = blink_object
	_duration_timer.start()
	_blink_timer.start()


func _blink() -> void:
	if _is_visible:
		_set_visible(false)
	else:
		_set_visible(true)
	_is_visible = !_is_visible


func _set_visible(isVisible: bool) -> void:
	if isVisible:
		_blink_object.modulate.a = 1
	else:
		_blink_object.modulate.a = 0


func _on_BlinkTimer_timeout() -> void:
	_blink()


func _on_DurationTimer_timeout() -> void:
	_set_visible(true)
	_blink_timer.stop()
