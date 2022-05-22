extends Node2D
class_name Skill

export var skill_name: String
export(String, MULTILINE) var skill_description: String
export var skill_icon: Resource
export var cooldown_duration: float

onready var cooldown_timer: Timer = $CooldownTimer

var cooldown_indicator: float = cooldown_duration * 60
var current_cooldown_indicator: float = cooldown_duration * 60


func _ready() -> void:
	cooldown_indicator = cooldown_duration * 60
	current_cooldown_indicator = cooldown_duration * 60
	cooldown_timer.set_wait_time(cooldown_duration)


func activate_skill() -> void:
	print("skill activated")
