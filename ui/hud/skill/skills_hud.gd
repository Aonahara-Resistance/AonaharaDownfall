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
onready var skill_one_hover_timer: Timer = $SkillOneHoverTimer
onready var skill_two_hover_timer: Timer = $SkillTwoHoverTimer

var skill_one_tooltip
var skill_two_tooltip


func _ready() -> void:
  GameSignal.connect("party_spawned",self, "_on_party_spawned")
  GameSignal.connect("party_member_changed",self, "_on_party_member_changed")
  GameSignal.connect("skill_cooldown_changed",self, "_on_skill_cooldown_changed")

func _on_skill_cooldown_changed(character):
  process_time_label(character)
  process_cooldown(character)

func _on_party_spawned(character, _party_members, _reserved_member):
  update_skill(character)
  skill_one_tooltip = character.skill_one.tooltip
  skill_two_tooltip = character.skill_two.tooltip

func _on_party_member_changed(character):
  update_skill(character)
  process_time_label(character)
  process_cooldown(character)
  skill_one_tooltip = character.skill_one.tooltip
  skill_two_tooltip = character.skill_two.tooltip

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


func _on_Skill2_mouse_exited():
  skill_two_tooltip.rect.visible = false
  skill_two_hover_timer.stop()


func _on_Skill2_mouse_entered():
  skill_two_hover_timer.start()


func _on_Skill1_mouse_exited():
  skill_one_tooltip.rect.visible = false
  skill_one_hover_timer.stop()

func _on_Skill1_mouse_entered():
  skill_one_hover_timer.start()


func _on_SkillOneHoverTimer_timeout():
  skill_one_tooltip.rect.rect_position = get_global_mouse_position() - skill_one_tooltip.rect.rect_size
  var content_size = skill_one_tooltip.vbox.get_combined_minimum_size()
  skill_one_tooltip.rect.rect_min_size  = Vector2(content_size + Vector2(10,10))
  skill_one_tooltip.rect.visible = true

func _on_SkillTwoHoverTimer_timeout():
  skill_two_tooltip.rect.rect_position = get_global_mouse_position() - skill_two_tooltip.rect.rect_size
  var content_size = skill_two_tooltip.vbox.get_combined_minimum_size()
  skill_two_tooltip.rect.rect_min_size  = Vector2(content_size + Vector2(10,10))
  skill_two_tooltip.rect.visible = true

