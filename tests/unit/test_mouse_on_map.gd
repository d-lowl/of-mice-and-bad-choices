extends GutTest

var map: Map

func before_each():
	map = autofree(load("res://map/map.tscn").instantiate())
	add_child_autofree(map)
	
	
func test_mouse_move_to_elder():
	# Test that mice move towards the elder mouse when there's a clear sight of them
	var level = load("res://tests/unit/maps/test_map_elder.tscn")
	map.load_level(level)
	map.move_mice()

	# Moving mouse moved one to the left
	var expected_move_position = Vector2(6, 6)
	assert_eq(SnapUtils.get_tile_map_position($Map/Level0/MovingMouse.position), expected_move_position)
	
	# The rest of them never moved
	assert_eq($Map/Level0/ClearMouse.position, $Map/Level0/ClearMouse.spawn_position)
	assert_eq($Map/Level0/LostMouse.position, $Map/Level0/LostMouse.spawn_position)
	assert_eq($Map/Level0/StuckMouse.position, $Map/Level0/StuckMouse.spawn_position)
	

func test_mouse_attracted_by_cheese():
	# Test that mice move towards the attractful cheese, when there's a path
	var level = load("res://tests/unit/maps/test_map_attract.tscn")
	map.load_level(level)
	map.move_mice()
	
	# All mice that are in range of influence of an attractive cheese
	assert_eq($Map/Level0/VerticalMouse.position, SnapUtils.set_tile_map_position(Vector2(5, 3)))
	assert_eq($Map/Level0/HorizontalMouse.position, SnapUtils.set_tile_map_position(Vector2(5, 5)))
	assert_eq($Map/Level0/FarMouse.position, SnapUtils.set_tile_map_position(Vector2(8, 3)))
	assert_eq($Map/Level0/CornerMouse.position, SnapUtils.set_tile_map_position(Vector2(12, 2)))
	
	# This mouse is too far away
	assert_eq($Map/Level0/TooFarMouse.position, SnapUtils.set_tile_map_position(Vector2(8, 5)))
	
	# This mouse has no path
	assert_eq($Map/Level0/HiddenMouse.position, SnapUtils.set_tile_map_position(Vector2(13, 6)))
	
	# This mouse has a repelling cheese
	assert_eq($Map/Level0/WrongMouse.position, SnapUtils.set_tile_map_position(Vector2(7, 7)))
	
	
func run_level_with_mouse_test_cases(map_path: String):
	var level = load(map_path)
	map.load_level(level)
	
	var cases = MouseTestCase.cast_all_cases(get_tree().get_nodes_in_group(MouseTestCase.MTC_GROUP_NAME))
	
	cases.any(func(case): 
		print(case.done)
		return false
	)
	#for i in [0,1,2,3]:	
	while (cases.any(func(case): return not case.done)):
		map.move_mice()
		for case in cases:
			if not case.done:
				case.steps_left -= 1
				if case.steps_left == 0:
					case.done = true
					assert_eq(case.get_mouse_position(), case.expected_position)
				print(case, case.steps_left, case.done)
	
func test_mouse_repelled_by_cheese():
	# Test that mice move away from the repelling cheese, when there's a path
	run_level_with_mouse_test_cases("res://tests/unit/maps/test_map_repel.tscn")
