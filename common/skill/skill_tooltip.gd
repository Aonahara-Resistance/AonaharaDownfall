extends CanvasLayer
class_name SkillTooltip

onready var vbox: VBoxContainer = $NinePatchRect/MarginContainer/VBoxContainer
onready var rect: NinePatchRect = $NinePatchRect

onready var texture: TextureRect = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/Texture
onready var skill_name: Label = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/Name
onready var desc: Label = $NinePatchRect/MarginContainer/VBoxContainer/Desc
onready var effect: Label = $NinePatchRect/MarginContainer/VBoxContainer/Effect

func _ready() -> void:
  var content_heightt = vbox.get_combined_minimum_size()
  rect.rect_min_size  = Vector2(content_heightt + Vector2(10,vbox.rect_size.y+10))
