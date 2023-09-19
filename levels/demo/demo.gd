extends Level

onready var ambience = $Ambience
onready var animation_cutscene = $Cutscene/AnimationPlayer
onready var nom_c = $Cutscene/Nom

func _ready() -> void:
  # Un coment for debuggig without waiting for loading
  #GameSignal.emit_signal("level_loaded", spawn.global_position, ysort)
  #pass

  # Run Starting Cutscene:
  GameSignal.emit_signal("cutscene_started")
  cutscene.pause_mode = PAUSE_MODE_PROCESS
  cutscene.visible = true
  camera_c.global_position = nom_c.global_position
  var tween: SceneTreeTween = get_tree().create_tween()
  tween.tween_property(ambience, "volume_db", -30.0, 5)
  tween.set_pause_mode(tween.TWEEN_PAUSE_PROCESS)
  GlobalCamera.camera2D.current = false
  nom_c.frame = 24
  gameplay.visible = false
  get_tree().paused = true
  animation_bar.play("in")
  camera_c.current = true
  yield(tween.tween_property($Cutscene/ColorRect, "modulate", Color.transparent, 5), "finished")
  animation_cutscene.play("wake_up")
  
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
  if anim_name == "wake_up":
    animation_cutscene.play("idle")
    yield(get_tree().create_timer(0.3), "timeout")
    nom_c.scale.x = -1
    yield(get_tree().create_timer(0.3), "timeout")
    nom_c.scale.x = 1
    var dialog = Dialogic.start("opening")
    dialog.pause_mode = PAUSE_MODE_PROCESS
    add_child(dialog)
    dialog.connect("dialogic_signal", self, "dialog_listener")
 

func dialog_listener(arg: String) -> void:
  if arg == "end":
    animation_bar.play("out")
    gameplay.visible = true
    cutscene.visible = false
    GameSignal.emit_signal("cutscene_ended", nom_c.global_position)
    GlobalCamera.camera2D.smoothing_enabled = false 
    get_tree().paused = false
    var title: AreaTitle = area_title.instance()
    title.area_name = "Desolated Station"
    add_child(title)
    yield(get_tree().create_timer(0.1), "timeout")
    GlobalCamera.camera2D.smoothing_enabled = true 


func _on_Area2D_body_entered(_body: Node) -> void:
  get_tree().create_tween().tween_property($Gameplay/YSort/MovementLabel, "percent_visible", 1.0, 2)

func _on_Area2D2_body_entered(_body:Node) -> void:
  get_tree().create_tween().tween_property($Gameplay/YSort/DashLabel, "percent_visible", 1.0, 2)
