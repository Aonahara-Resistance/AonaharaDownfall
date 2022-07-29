extends GdUnitTestSuite
class_name BlinkerTest

#warning-ignore-all:return_value_discarded
var spy_scene: Blinker


func before():
	var scene_path: PackedScene = load("res://common/collisions/blinker.tscn")
	var scene_instance = scene_path.instance()
	spy_scene = spy(scene_instance)
	spy_scene.duration = 1
	spy_scene.blink_interval = 0.1


func before_test():
	reset(spy_scene)


func test_blink():
	scene_runner(spy_scene)

	var node_mock = Node2D.new()
	add_child(node_mock)
	var blink_object = spy(auto_free(node_mock))

	assert_float(blink_object.modulate.a).is_equal(1)
	spy_scene.start_blinking(blink_object)
	yield(get_tree().create_timer(0.1), "timeout")
	assert_float(blink_object.modulate.a, 0)

	yield(get_tree().create_timer(1), "timeout")
	assert_float(blink_object.modulate.a).is_equal(1)
