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
	
