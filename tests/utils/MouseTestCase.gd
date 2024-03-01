extends Node2D
class_name MouseTestCase

const MTC_GROUP_NAME = "MouseTestCaseGroup"

@export var steps_left = 0
@export var done = false

@onready var mouse: Mouse = $Mouse
@onready var expected_position = SnapUtils.get_tile_map_position($TestMarker.position)


func _init():
	add_to_group(MTC_GROUP_NAME)


func get_mouse_position() -> Vector2:
	return SnapUtils.get_tile_map_position(mouse.position)


static func cast_all_cases(nodes: Array[Node]) -> Array[MouseTestCase]:
	var cases: Array[MouseTestCase] = []
	for node in nodes:
		if node is MouseTestCase:
			cases.append(node as MouseTestCase)
	return cases
