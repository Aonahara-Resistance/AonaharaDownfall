extends Node2D

# * To anyone who have to work with this file in the future
# * I am terribly sorry
# * signed posei

# Posei ended up being the one who have to work with it
# Damn

# warnings-disable
# ^ this'll do :KoroneEye:

# Just don't touch this, it works don't touch anything

onready var tween: Tween = $Tween

onready var rect: ColorRect = $ColorRect
onready var bg: Node2D = $bg
onready var camera = $Camera2D

var ajig: bool = false

var params = {
	show_progress_bar = true,
}


func _ready():
	$Aonares.gravity_scale = 0
	var _interpolate: bool = tween.interpolate_property(rect, "modulate:a", 1.0, 0.0, 2.0, 3, 1)
	var _tween_status: bool = tween.start()


func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	$Aonares.gravity_scale = 10
	$Aonares.sleeping = false


func _on_VisibilityNotifier2D_screen_exited():
	for bgss in bg.get_children():
		$ModulateTween.interpolate_property(bgss, "modulate:g", 1.0, 0.0, 2.5, 3, 1)
		$ModulateTween.interpolate_property(bgss, "modulate:b", 1.0, 0.0, 2.5, 3, 1)
		$ModulateTween.start()
	var _interpolate: bool = tween.interpolate_property(rect, "modulate:a", 0.0, 1.0, 5.0, 3, 1)
	var _tween_status: bool = tween.start()


func _on_Aonares_body_entered(body):
	$Aonares/Particles2D.set_emitting(true)
	if !ajig:
		Shake.shake(100, 0.1)
		$Aonares/boom.play()
		ajig = true


func _on_ModulateTween_tween_completed(object, key):
	for bgss in bg.get_children():
		$ModulateTween.stop_all()
	tween.stop_all()
	Game.change_scene("res://menus/main_menu/main_menu.tscn", params)


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			for bgss in bg.get_children():
				$ModulateTween.stop_all()
			tween.stop_all()
			Game.change_scene("res://menus/main_menu/main_menu.tscn", params)
