extends NinePatchRect
class_name CharacterItem

var party_index
var character_name

onready var character_texture = $"%CharacterTexture"
onready var skill_one_texture = $"%SkillOneTexture"
onready var skill_two_texture = $"%SkillTwoTexture"

func get_drag_data(_position):
  var data = {}
  data["origin"] = self
  data["target_character"] = character_texture.texture
  data["target_skill_one"] = skill_one_texture.texture
  data["target_skill_two"] = skill_two_texture.texture

  return data

func can_drop_data(_position, _data):
  return true

func drop_data(_position, data):
  data["origin"].character_texture.texture = character_texture.texture
  data["origin"].skill_one_texture.texture = skill_one_texture.texture
  data["origin"].skill_two_texture.texture = skill_two_texture.texture
  
  character_texture.texture = data["target_character"]
  skill_one_texture.texture = data["target_skill_one"]
  skill_two_texture.texture = data["target_skill_two"]
