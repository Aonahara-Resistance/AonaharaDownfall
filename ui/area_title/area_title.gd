extends CanvasLayer

# Essentially this thing just
# Enter -> Starts fading out -> Freeing

onready var tween: Tween = $Tween


func _ready() -> void:
	start_fade_process()


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()


func start_fade_process() -> void:
	var _interpolate: bool = tween.interpolate_property(
		$CenterContainer, "modulate:a", 1.0, 0.0, 2, 3, 1
	)
	yield(get_tree().create_timer(3.0), "timeout")
	var _tween_status: bool = tween.start()
