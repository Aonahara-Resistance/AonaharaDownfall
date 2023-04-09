extends CanvasLayer
class_name SkillTooltip

onready var vbox = $NinePatchRect/MarginContainer/VBoxContainer
onready var rect = $NinePatchRect

onready var texture = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/Texture
onready var skill_name = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/Name
onready var desc = $NinePatchRect/MarginContainer/VBoxContainer/Desc
onready var effect = $NinePatchRect/MarginContainer/VBoxContainer/Effect

func _ready():
  var content_heightt = vbox.get_combined_minimum_size()
  rect.rect_min_size  = Vector2(content_heightt + Vector2(10,vbox.rect_size.y+10))
