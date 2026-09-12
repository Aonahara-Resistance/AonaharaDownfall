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

# Fixed width so the autowrap labels have a stable wrap point; the panel only
# grows downwards from there.
# ponytail: assumes the wrapped text fits the 180px-tall viewport. Add a max
# height with a scroll container if descriptions ever get longer.
const TOOLTIP_WIDTH := 110.0
const TOOLTIP_PADDING := 5.0

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
  _show_tooltip(skill_one_tooltip)

func _on_SkillTwoHoverTimer_timeout():
  _show_tooltip(skill_two_tooltip)

func _show_tooltip(tooltip) -> void:
  tooltip.rect.rect_min_size = Vector2(TOOLTIP_WIDTH, 0)
  tooltip.rect.rect_size = Vector2(TOOLTIP_WIDTH, 0)
  _place_tooltip(tooltip)
  tooltip.rect.visible = true
  yield(get_tree(), "idle_frame")
  _place_tooltip(tooltip)

func _place_tooltip(tooltip) -> void:
  var size := Vector2(
    TOOLTIP_WIDTH,
    tooltip.vbox.get_combined_minimum_size().y + TOOLTIP_PADDING * 2
  )
  tooltip.rect.rect_min_size = size
  tooltip.rect.rect_size = size
  var screen: Vector2 = get_viewport().get_visible_rect().size
  var pos: Vector2 = get_global_mouse_position() - size
  tooltip.rect.rect_position = Vector2(
    clamp(pos.x, 0, max(0, screen.x - size.x)),
    clamp(pos.y, 0, max(0, screen.y - size.y))
  )

