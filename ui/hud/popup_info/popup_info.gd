extends CanvasLayer
class_name PopupInfo

onready var label: Label = $HBoxContainer/Label
onready var animation: AnimationPlayer = $AnimationPlayer


func pop_info(info: String):
	label.set_text(info)
	animation.play("pop")
