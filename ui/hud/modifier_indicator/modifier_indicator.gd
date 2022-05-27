extends TextureRect
class_name ModifierIndicator

#func _ready() -> void:
#	if !Party.is_party_empty():
#		skill_one_timer = Party.current_character().skill_one.cooldown_timer
#		skill_two_timer = Party.current_character().skill_two.cooldown_timer
#	else:
#		skill_one_timer = $SkillOneTimer
#		skill_two_timer = $SkillTwoTimer
#
#
#func _process(_delta) -> void:
#	if !Party.is_party_empty():
#		process_cooldown()
#
#
#func update_skill() -> void:
#	_set_skills_texture()
#	_set_skills_timer()
#	_set_skills_cooldown_indicator()
#
#
#func process_cooldown() -> void:
#	skill_one_cooldown_progress.value = Party.current_character().skill_one.current_cooldown_indicator
#	skill_two_cooldown_progress.value = Party.current_character().skill_two.current_cooldown_indicator
#	skill_one_cooldown_progress.set_visible(
#		!Party.current_character().skill_one.cooldown_timer.is_stopped()
#	)
#	skill_two_cooldown_progress.set_visible(
#		!Party.current_character().skill_two.cooldown_timer.is_stopped()
#	)
#
#
#func _set_skills_texture() -> void:
#	skill_one.set_texture(Party.current_character().skill_one.skill_icon)
#	skill_two.set_texture(Party.current_character().skill_two.skill_icon)
#
#
#func _set_skills_timer() -> void:
#	skill_one_timer.set_wait_time(Party.current_character().skill_one.cooldown_duration)
#	skill_two_timer.set_wait_time(Party.current_character().skill_two.cooldown_duration)
#
#
#func _set_skills_cooldown_indicator() -> void:
#	skill_one_cooldown_progress.max_value = Party.current_character().skill_one.cooldown_indicator
#	skill_two_cooldown_progress.max_value = Party.current_character().skill_two.cooldown_indicator
