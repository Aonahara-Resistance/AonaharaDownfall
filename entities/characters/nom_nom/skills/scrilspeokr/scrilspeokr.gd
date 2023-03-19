extends Skill

onready var family_buff = preload("res://entities/characters/nom_nom/skills/scrilspeokr/family/family.tscn")

func activate_skill() -> void:
  if cooldown_timer.is_stopped():
    character.apply_modifier(family_buff.instance())
    cooldown_timer.start()
