extends HBoxContainer
class_name SkillHud

onready var skill_one: TextureRect = $Skill1
onready var skill_two: TextureRect = $Skill2
onready var skill_one_time_left: Label = $Skill1/CooldownLabel
onready var skill_two_time_left: Label = $Skill2/CooldownLabel
onready var skill_one_cooldown_progress: TextureProgress = $Skill1/CooldownIndicator
onready var skill_two_cooldown_progress: TextureProgress = $Skill2/CooldownIndicator

onready var skill_one_timer: Timer = $SkillOneTimer
onready var skill_two_timer: Timer = $SkillTwoTimer

func _ready() -> void:
  GameSignal.connect("party_spawned",self, "_on_party_spawned")
  GameSignal.connect("party_member_changed",self, "_on_party_member_changed")
  GameSignal.connect("skill_cooldown_changed",self, "_on_skill_cooldown_changed")

func _on_skill_cooldown_changed(character):
  process_time_label(character)
  process_cooldown(character)

func _on_party_spawned(character):
  update_skill(character)

func _on_party_member_changed(character):
  update_skill(character)
  process_time_label(character)
  process_cooldown(character)

func update_skill(character) -> void:
  _set_skills_texture(character)
  _set_skills_timer(character)
  _set_skills_cooldown_indicator(character)

func process_cooldown(character) -> void:
  skill_one_cooldown_progress.value = character.skill_one.current_cooldown_indicator
  skill_two_cooldown_progress.value = character.skill_two.current_cooldown_indicator
  skill_one_cooldown_progress.set_visible(
    !character.skill_one.cooldown_timer.is_stopped()
  )
  skill_two_cooldown_progress.set_visible(
    !character.skill_two.cooldown_timer.is_stopped()
  )

func process_time_label(character) -> void:
  skill_one_time_left.set_visible(
    !character.skill_one.cooldown_timer.is_stopped()
  )
  skill_two_time_left.set_visible(
    !character.skill_two.cooldown_timer.is_stopped()
  )
  skill_one_time_left.set_text(
    "%.1f" % character.skill_one.cooldown_timer.get_time_left()
  )
  skill_two_time_left.set_text(
    "%.1f" % character.skill_two.cooldown_timer.get_time_left()
  )

func _set_skills_texture(character) -> void:
  skill_one.set_texture(character.skill_one.skill_icon)
  skill_two.set_texture(character.skill_two.skill_icon)

func _set_skills_timer(character) -> void:
  skill_one_timer = character.skill_one.cooldown_timer
  skill_two_timer = character.skill_two.cooldown_timer
  skill_one_timer.set_wait_time(character.skill_one.cooldown_duration)
  skill_two_timer.set_wait_time(character.skill_two.cooldown_duration)

func _set_skills_cooldown_indicator(character) -> void:
  skill_one_cooldown_progress.max_value = character.skill_one.cooldown_indicator
  skill_two_cooldown_progress.max_value = character.skill_two.cooldown_indicator

func _on_Skill1_gui_input(event: InputEvent) -> void:
  if event.is_action_pressed("left_click"):
    GameSignal.emit_signal("skill_one_pressed")

func _on_Skill2_gui_input(event: InputEvent) -> void:
  if event.is_action_pressed("left_click"):
    GameSignal.emit_signal("skill_two_pressed")
