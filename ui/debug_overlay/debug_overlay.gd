extends CanvasLayer

# Debug overlay by Gonkee
# Posei snatched it, big thanks Gonkee

var stats: Array = []
var label_text: String = ""
onready var label: Label = $Label


func add_stat(stat_name, object, stat_ref, is_method, arg = "") -> void:
	stats.append([stat_name, object, stat_ref, is_method, arg])


func _process(_delta) -> void:
	label_text = ""

	# These functions append new informations to label_text
	set_fps()
	set_static_memory()
	set_stats()

	label.text = label_text


func set_fps() -> void:
	var fps: float = Engine.get_frames_per_second()
	label_text += str("FPS: ", fps)
	label_text += "\n"


func set_static_memory() -> void:
	var mem: int = OS.get_static_memory_usage()
	label_text += str("Static Memory: ", String.humanize_size(mem))
	label_text += "\n"


func set_stats() -> void:
	for s in stats:
		var value = null

		if s[1] && weakref(s[1]).get_ref():
			if s[3] && s[4]:
				value = s[1].call(s[2], s[4])
			elif s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		label_text += str(s[0], ": ", value)
		label_text += "\n"
