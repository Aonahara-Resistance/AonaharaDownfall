extends GdUnitTestSuite
class_name BlinkerTest

var blinker: Blinker
var blink_object: Node2D


func before_test() -> void:
	_reset_spies()
	scene_runner(blinker)
	add_child(blink_object)


func test_blink() -> void:
	assert_float(blink_object.modulate.a).is_equal(1)

	blinker.start_blinking(blink_object)
	yield(get_tree().create_timer(0.3), "timeout")
	assert_float(blink_object.modulate.a).is_equal(0)

	yield(get_tree().create_timer(1), "timeout")
	assert_float(blink_object.modulate.a).is_equal(1)


func _reset_spies() -> void:
	var blinker_instance: Blinker = preload("res://common/collisions/blinker.tscn").instance()
	blinker = spy(auto_free(blinker_instance))
	blinker.duration = 1
	blinker.blink_interval = 0.1

	var node_instance = Node2D.new()
	blink_object = spy(auto_free(node_instance))
