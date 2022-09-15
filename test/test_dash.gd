extends GdUnitTestSuite
class_name DashTest

var dash: Dash
var entity: Character


func before_test() -> void:
	_reset_spies()
	_set_entity_stats()
	scene_runner(dash)
	add_child(entity)


func test_stamina_reduction() -> void:
	assert_int(entity.get_attribute("stamina")).is_equal(3)
	dash.start_dash(entity)
	assert_int(entity.get_attribute("stamina")).is_equal(2)


func test_dash() -> void:
	assert_int(entity.get_attribute("acceleration")).is_equal(80)
	dash.start_dash(entity)
	assert_int(entity.get_attribute("acceleration")).is_equal(80 + 300)


func test_dash_duration() -> void:
	assert_int(entity.get_attribute("acceleration")).is_equal(80)
	dash.start_dash(entity)
	assert_int(entity.get_attribute("acceleration")).is_equal(80 + 300)
	yield(get_tree().create_timer(0.2), "timeout")
	assert_int(entity.get_attribute("acceleration")).is_equal(80)


func test_dash_cooldown() -> void:
	assert_int(entity.get_attribute("acceleration")).is_equal(80)
	dash.start_dash(entity)
	assert_int(entity.get_attribute("acceleration")).is_equal(80 + 300)
	yield(get_tree().create_timer(0.2), "timeout")

	dash.start_dash(entity)
	assert_int(entity.get_attribute("acceleration")).is_equal(80)


func _set_entity_stats() -> void:
	if entity != null:
		entity.init(5, 3, 2.0, 80, 5, 0, 100, 3, 12, 1, 0.2, 2, 300, 0.2, true)
		# hp: 5
		# stamina: 3
		# stamina_regen: 2.0
		# acceleration: 80
		# max_hp: 5
		# extra_hp: 0
		# max_speed: 100
		# max_stamina: 3
		# base_damage: 12
		# stamina_regen_rate: 1
		# dash duration: 0.2
		# dash_cooldown: 2
		# dash_spped: 300
		# friction: 0.2
		# receives_knockback: true


func _reset_spies() -> void:
	var dash_instance: Dash = preload("res://common/dash/dash.tscn").instance()
	dash = spy(auto_free(dash_instance))
	var entity_instance: Character = preload("res://entities/characters/character.tscn").instance()
	entity = spy(auto_free(entity_instance))
