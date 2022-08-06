extends GdUnitTestSuite
class_name HitboxTest

var hitbox: Hitbox


func before_test() -> void:
	_reset_spies()
	reset(hitbox)


func test_get_damage() -> void:
	hitbox.set_damage(20)

	assert_int(hitbox.get_hitbox_damage()).is_equal(20)


func test_no_negative_damage() -> void:
	hitbox.set_damage(-10)

	assert_int(hitbox.get_hitbox_damage()).is_equal(0)


func test_get_randomized_damage() -> void:
	hitbox.set_damage(30)

	assert_int(hitbox.get_randomized_hitbox_damage()).is_between(int(30 * 0.9), int(30 * 1.2))


func _reset_spies() -> void:
	var hitbox_instance: Hitbox = preload("res://common/collisions/hitbox.tscn").instance()
	hitbox = spy(hitbox_instance)
