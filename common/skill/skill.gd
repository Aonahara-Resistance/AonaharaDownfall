extends Node2D
class_name Skill

export var character_path: NodePath
export var skill_name: String
export(String, MULTILINE) var skill_description: String
export var skill_icon: Resource
export var cooldown_duration: float

onready var cooldown_timer: Timer = $CooldownTimer
onready var character = get_node(character_path)

var cooldown_indicator: float = cooldown_duration * 60
var current_cooldown_indicator: float = cooldown_duration * 60


func _ready() -> void:
  cooldown_indicator = cooldown_duration * 60
  current_cooldown_indicator = cooldown_duration * 60
  cooldown_timer.set_wait_time(cooldown_duration)

func _process(delta) -> void:
  if !cooldown_timer.is_stopped():
    current_cooldown_indicator -= 60 * delta
    if character.sprite.visible == true:
      GameSignal.emit_signal("skill_cooldown_changed", character)


func activate_skill() -> void:
  print("skill activated")


func _on_CooldownTimer_timeout() -> void:
  current_cooldown_indicator = cooldown_indicator
