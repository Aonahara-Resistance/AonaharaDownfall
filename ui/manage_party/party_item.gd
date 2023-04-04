extends NinePatchRect
class_name CharacterItem

var party_index
var character_name


onready var character_texture = $"%CharacterTexture"
onready var skill_one_texture = $"%SkillOneTexture"
onready var skill_two_texture = $"%SkillTwoTexture"
onready var popup = $"PopupDialog"

func get_drag_data(_position):
  var data = {}
  data["origin"] = self
  data["target_character"] = character_texture.texture
  data["target_skill_one"] = skill_one_texture.texture
  data["target_skill_two"] = skill_two_texture.texture

  return data

func can_drop_data(_position, _data):
  return true

func reselect_active_party(character_namee) -> bool:
  return character_name == character_namee

func drop_data(_position, data):
  data["origin"].character_texture.texture = character_texture.texture
  data["origin"].skill_one_texture.texture = skill_one_texture.texture
  data["origin"].skill_two_texture.texture = skill_two_texture.texture
  
  character_texture.texture = data["target_character"]
  skill_one_texture.texture = data["target_skill_one"]
  skill_two_texture.texture = data["target_skill_two"]


  GameSignal.emit_signal("party_order_changed", data["origin"].party_index, party_index)

func _on_MarginContainer_gui_input(event:InputEvent):
  if event.is_action_pressed("left_click"):
    popup.rect_position = get_global_mouse_position()
    popup.popup()


func _on_Label_gui_input(event:InputEvent):
  if event.is_action_pressed("left_click"):
    GameSignal.emit_signal("remove_party_member_requested", party_index)

