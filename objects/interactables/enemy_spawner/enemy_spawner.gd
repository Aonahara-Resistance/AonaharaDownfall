extends Node2D

export var enemy: PackedScene
export var spawn_time: int
export var initial_enemy: int
export var max_spawn: int

onready var spawn_timer: Timer = $SpawnTimer

func _on_SpawnTimer_timeout():
	var spawned_enemy = get_tree().get_nodes_in_group(name)
	if !spawned_enemy.size() >= max_spawn:
		var enemy_instance = enemy.instance()
		get_tree().current_scene.add_child(enemy_instance)
		enemy_instance.global_position = global_position
		enemy_instance.spawn_group = name
		enemy_instance.add_to_group(name)
