extends GdUnitTestSuite
class_name HitboxTest

var hitbox: Hitbox


#warning-ignore-all:return_value_discarded
func before():
	var scene_path: PackedScene = load("res://common/collisions/hitbox.tscn")
	var scene_instance = scene_path.instance()
	hitbox = spy(scene_instance)


func before_test():
	reset(hitbox)


func test_get_damage():
	hitbox.set_damage(20)
	assert_int(hitbox.get_hitbox_damage()).is_equal(20)


func test_no_negative_damage():
	hitbox.set_damage(-10)
	assert_int(hitbox.get_hitbox_damage()).is_equal(0)


func test_get_randomized_damage():
	hitbox.set_damage(30)
	assert_int(hitbox.get_randomized_hitbox_damage()).is_between(int(30 * 0.9), int(30 * 1.2))
