extends GdUnitTestSuite
class_name DashTest

var spy_scene: Dash
var entity: Character


func before():
	var scene_path: PackedScene = load("res://common/dash/dash.tscn")
	var scene_instance = scene_path.instance()
	spy_scene = spy(scene_instance)


func before_test():
	reset(spy_scene)
	scene_runner(spy_scene)

	var node_mock = Character.new()
	node_mock.dash_speed = 300
	node_mock.stamina = 4
	node_mock.stamina_regen = 2
	node_mock.acceleration = 100
	node_mock.max_speed = 300
	node_mock.max_stamina = 4
	node_mock.stamina_regen = 1
	node_mock.dash_duration = 0.2
	node_mock.dash_cooldown = 2
	entity = spy(auto_free(node_mock))
	add_child(entity)


func test_dash():
	spy_scene.start_dash(entity)
	assert_float(entity.get_attribute("stamina")).is_equal(3)
