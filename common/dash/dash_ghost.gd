extends Sprite

onready var _tween: Tween = $Tween


func _ready() -> void:
	var _interpolate: bool = _tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
	var _tween_status: bool = _tween.start()


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
