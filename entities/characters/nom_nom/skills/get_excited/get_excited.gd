extends Skill

onready var excited_buff = preload("res://entities/characters/nom_nom/skills/get_excited/excited/excited.tscn")

func activate_skill():
	if cooldown_timer.is_stopped():
		character.apply_modifier(excited_buff.instance())
		cooldown_timer.start()
	else:
		UiUtils.show_info("post nut clarity")
