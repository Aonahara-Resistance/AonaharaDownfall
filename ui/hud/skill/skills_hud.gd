extends HBoxContainer
class_name SkillHud

onready var skill_one: TextureRect = $Skill1
onready var skill_two: TextureRect = $Skill2
onready var skill_one_time_left: Label = $Skill1/CooldownLabel
onready var skill_two_time_left: Label = $Skill2/CooldownLabel
onready var skill_one_cooldown_progress: TextureProgress = $Skill1/CooldownIndicator
onready var skill_two_cooldown_progress: TextureProgress = $Skill2/CooldownIndicator

var skill_one_timer: Timer
var skill_two_timer: Timer


func _ready() -> void:
	if !Party.is_party_empty():
		skill_one_timer = Party.current_character().skill_one.cooldown_timer
		skill_two_timer = Party.current_character().skill_two.cooldown_timer
	else:
		skill_one_timer = $SkillOneTimer
		skill_two_timer = $SkillTwoTimer


func _process(_delta) -> void:
	if !Party.is_party_empty():
		process_time_label()
		process_cooldown()


func update_skill() -> void:
	_set_skills_texture()
	_set_skills_timer()
	_set_skills_cooldown_indicator()


func process_cooldown() -> void:
	skill_one_cooldown_progress.value = Party.current_character().skill_one.current_cooldown_indicator
	skill_two_cooldown_progress.value = Party.current_character().skill_two.current_cooldown_indicator
	skill_one_cooldown_progress.set_visible(
		!Party.current_character().skill_one.cooldown_timer.is_stopped()
	)
	skill_two_cooldown_progress.set_visible(
		!Party.current_character().skill_two.cooldown_timer.is_stopped()
	)


func process_time_label() -> void:
	skill_one_time_left.set_visible(
		!Party.current_character().skill_one.cooldown_timer.is_stopped()
	)
	skill_two_time_left.set_visible(
		!Party.current_character().skill_two.cooldown_timer.is_stopped()
	)
	skill_one_time_left.set_text(
		"%.1f" % Party.current_character().skill_one.cooldown_timer.get_time_left()
	)
	skill_two_time_left.set_text(
		"%.1f" % Party.current_character().skill_two.cooldown_timer.get_time_left()
	)


func _set_skills_texture() -> void:
	skill_one.set_texture(Party.current_character().skill_one.skill_icon)
	skill_two.set_texture(Party.current_character().skill_two.skill_icon)


func _set_skills_timer() -> void:
	skill_one_timer.set_wait_time(Party.current_character().skill_one.cooldown_duration)
	skill_two_timer.set_wait_time(Party.current_character().skill_two.cooldown_duration)


func _set_skills_cooldown_indicator() -> void:
	skill_one_cooldown_progress.max_value = Party.current_character().skill_one.cooldown_indicator
	skill_two_cooldown_progress.max_value = Party.current_character().skill_two.cooldown_indicator


func _on_Skill1_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Party.current_character().skill_one.activate_skill()


func _on_Skill2_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Party.current_character().skill_two.activate_skill()
