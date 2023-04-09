extends CanvasLayer
class_name AreaTitle

# Essentially this thing just
# Enter -> Starts fading out -> Freeing

var area_name: String

func _ready() -> void:
  $CenterContainer/Label.text = area_name
  var tween = get_tree().create_tween()
  tween.tween_property($CenterContainer, "modulate", Color(1,1,1,1), 2)
  yield(tween.tween_property($CenterContainer, "modulate", Color.transparent, 2), "finished")
  queue_free()

