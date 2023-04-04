extends CanvasLayer

onready var reserve_container = $"%ReserveContainer"
onready var party_container = $"%PartyContainer"

onready var reserve_item = preload("res://ui/manage_party/reserve_item.tscn")
onready var party_item = preload("res://ui/manage_party/party_item.tscn")
onready var empty_party = preload("res://ui/manage_party/empty_party.tscn")


func _ready() -> void:
  GameSignal.connect("party_spawned", self, "_on_party_spawned")
  GameSignal.connect("reserve_deployed", self, "_on_reserve_deployed")
  GameSignal.connect("party_member_removed", self, "_on_party_member_removed")
  

func _unhandled_input(event: InputEvent) -> void:
  if visible && event.is_action_pressed("pause"):
    visible = false
    get_tree().paused = false
    get_tree().set_input_as_handled()
  if event.is_action_pressed("party"):
    visible = !visible
    get_tree().paused = visible
    get_tree().set_input_as_handled()

func _on_party_member_removed(party_members,reserve_member):
  for i in party_container.get_children():
    i.queue_free()
  for i in range(party_members.size()):
    var party_item_instance = party_item.instance()
    party_item_instance.party_index = i
    print(party_members[i])
    party_item_instance.get_node("%CharacterTexture").set_texture(party_members[i].character_sprite)
    party_item_instance.get_node("%SkillOneTexture").set_texture(party_members[i].skill_one.skill_icon)
    party_item_instance.get_node("%SkillTwoTexture").set_texture(party_members[i].skill_two.skill_icon)
    party_container.add_child(party_item_instance)
  for i in reserve_container.get_children():
    i.queue_free()
  for i in range(reserve_member.size()):
    var reserve_item_instance = reserve_item.instance()
    reserve_item_instance.index = i
    reserve_item_instance.get_node("TextureRect").texture = reserve_member[i].character_atlas
    reserve_container.add_child(reserve_item_instance)
  for _i in range(party_members.size(),3):
    var party_empty_instance = empty_party.instance()
    party_container.add_child(party_empty_instance)

func _on_reserve_deployed(party_members,reserve_member):
  for i in party_container.get_children():
    i.queue_free()
  for i in range(party_members.size()):
    var party_item_instance = party_item.instance()
    party_item_instance.party_index = i
    print(party_members[i])
    party_item_instance.get_node("%CharacterTexture").set_texture(party_members[i].character_sprite)
    party_item_instance.get_node("%SkillOneTexture").set_texture(party_members[i].skill_one.skill_icon)
    party_item_instance.get_node("%SkillTwoTexture").set_texture(party_members[i].skill_two.skill_icon)
    party_container.add_child(party_item_instance)
  for i in reserve_container.get_children():
    i.queue_free()
  for i in range(reserve_member.size()):
    var reserve_item_instance = reserve_item.instance()
    reserve_item_instance.index = i
    reserve_item_instance.get_node("TextureRect").texture = reserve_member[i].character_atlas
    reserve_container.add_child(reserve_item_instance)
  for _i in range(party_members.size(),3):
    var party_empty_instance = empty_party.instance()
    party_container.add_child(party_empty_instance)


func _on_party_spawned(_character, party_members, reserve_member):
  for i in range(party_members.size()):
    var party_item_instance = party_item.instance()
    party_item_instance.party_index = i
    party_item_instance.get_node("%CharacterTexture").set_texture(party_members[i].character_sprite)
    party_item_instance.get_node("%SkillOneTexture").set_texture(party_members[i].skill_one.skill_icon)
    party_item_instance.get_node("%SkillTwoTexture").set_texture(party_members[i].skill_two.skill_icon)
    party_container.add_child(party_item_instance)
  for i in range(reserve_member.size()):
    var reserve_item_instance = reserve_item.instance()
    reserve_item_instance.index = i
    reserve_item_instance.get_node("TextureRect").texture = reserve_member[i].character_atlas
    reserve_container.add_child(reserve_item_instance)
  for _i in range(party_members.size(),3):
    var party_empty_instance = empty_party.instance()
    party_container.add_child(party_empty_instance)
