extends Skill

export var character_path: NodePath

onready var character: Character = get_node(character_path)

onready var excited_buff = preload("res://entities/characters/nom_nom/skills/get_excited/excited/excited.tscn")


func _process(delta):
	if !cooldown_timer.is_stopped():
		current_cooldown_indicator -= 60 * delta


func _on_CooldownTimer_timeout() -> void:
	current_cooldown_indicator = cooldown_indicator


func activate_skill():
	if cooldown_timer.is_stopped():
		character.apply_modifier(excited_buff.instance())
		cooldown_timer.start()
	else:
		Hud.show_info("post nut clarity")
