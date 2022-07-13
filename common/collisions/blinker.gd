extends Node
class_name Blinker

var _isVisible: bool = true

onready var _blink_timer: Timer = $BlinkTimer
onready var _duration_timer: Timer = $DurationTimer

export(float) var _duration: float
export(float) var _blink_interval: float
export(NodePath) onready var _blink_object = get_node(_blink_object) as Node2D


func _ready() -> void:
	_duration_timer.set_wait_time(_duration)
	_blink_timer.set_wait_time(_blink_interval)


func start_blinking() -> void:
	_duration_timer.start()
	_blink_timer.start()


func _blink() -> void:
	if _isVisible:
		_setVisible(false)
	else:
		_setVisible(true)
	_isVisible = !_isVisible


func _setVisible(isVisible: bool) -> void:
	if isVisible:
		_blink_object.modulate.a = 1
	else:
		_blink_object.modulate.a = 0


func _on_BlinkTimer_timeout() -> void:
	_blink()


func _on_DurationTimer_timeout() -> void:
	_setVisible(true)
	_blink_timer.stop()
