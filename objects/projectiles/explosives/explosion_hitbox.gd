extends WeaponHitbox
class_name ExplosionHitbox

export var detonator_path: NodePath
onready var detonator = get_node(detonator_path)
onready var animation: AnimationPlayer = $AnimationPlayer
onready var collision: CollisionShape2D = $CollisionShape2D


func _ready():
	detonator.connect("exploded", self, "_on_exploded")


func _on_exploded():
	collision.set_deferred("disabled", false)
	animation.play("explode")
