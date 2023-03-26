extends Node2D

export var speed: float = 30
export var friction: float = 15
var shift_direction: Vector2 = Vector2.ZERO

onready var label = $Label

func _ready() -> void:
	randomize_fly_direction()

func _process(delta) -> void:
	move(delta)

func move(delta) -> void:
	global_position += speed * shift_direction * delta
	speed = max(speed - friction * delta, 0)

func randomize_fly_direction() -> void:
	shift_direction = Vector2(rand_range(-1, 1), rand_range(-2, 1))
