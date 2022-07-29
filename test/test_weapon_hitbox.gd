extends GdUnitTestSuite
class_name WeaponHitboxTest

var weapon_hitbox: WeaponHitbox


#warning-ignore-all:return_value_discarded
func before():
	var scene_path: PackedScene = load("res://common/collisions/weapon_hitbox.tscn")
	var scene_instance = scene_path.instance()
	weapon_hitbox = spy(scene_instance)


func before_test():
	reset(weapon_hitbox)


func test_get_damage():
	weapon_hitbox.set_damage(20)
	weapon_hitbox.set_character_damage(24)

	assert_int(weapon_hitbox.get_hitbox_damage()).is_equal(44)


func test_no_negative_damage():
	weapon_hitbox.set_damage(-100)
	weapon_hitbox.set_character_damage(-24)

	assert_int(weapon_hitbox.get_hitbox_damage()).is_equal(0)


func test_get_randomized_damage():
	weapon_hitbox.set_damage(30)
	weapon_hitbox.set_character_damage(55)

	assert_int(weapon_hitbox.get_randomized_hitbox_damage()).is_between(
		int((30 + 55) * 0.9), int((30 + 55) * 1.2)
	)
