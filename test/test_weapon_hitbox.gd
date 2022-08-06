extends GdUnitTestSuite
class_name WeaponHitboxTest

var weapon_hitbox: WeaponHitbox


func before_test() -> void:
	_reset_spies()
	reset(weapon_hitbox)


func test_get_damage() -> void:
	weapon_hitbox.set_damage(20)
	weapon_hitbox.set_character_damage(24)

	assert_int(weapon_hitbox.get_hitbox_damage()).is_equal(44)


func test_no_negative_damage() -> void:
	weapon_hitbox.set_damage(-100)
	weapon_hitbox.set_character_damage(-24)

	assert_int(weapon_hitbox.get_hitbox_damage()).is_equal(0)


func test_get_randomized_damage() -> void:
	weapon_hitbox.set_damage(30)
	weapon_hitbox.set_character_damage(55)

	assert_int(weapon_hitbox.get_randomized_hitbox_damage()).is_between(
		int((30 + 55) * 0.9), int((30 + 55) * 1.2)
	)


func _reset_spies() -> void:
	var weapon_hitbox_instance: WeaponHitbox = preload("res://common/collisions/weapon_hitbox.tscn").instance()
	weapon_hitbox = spy(weapon_hitbox_instance)
