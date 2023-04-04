extends NinePatchRect

onready var add_indicator = $AddIndicator
var index

func _ready():
  GameSignal.connect("deploy_reserve_requested", self, "_on_deploy_reserve_requested")
  GameSignal.connect("deploy_reserve_cancelled", self, "_on_deploy_reserve_cancelled")

func _on_deploy_reserve_requested(i):
  add_indicator.visible = true
  index = i

func _on_deploy_reserve_cancelled():
  add_indicator.visible = false

func _on_AddIndicator_gui_input(event:InputEvent):
  if event.is_action_pressed("left_click"):
    GameSignal.emit_signal("deploy_reserve_cancelled")
    GameSignal.emit_signal("deploy_reserve_request_sent", index)

