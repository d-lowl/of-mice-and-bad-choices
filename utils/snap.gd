extends Node
class_name SnapUtils

const TILE_SIZE = 64
const TILE_OFFSET = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)

static func snap_to_grid(pos: Vector2) -> Vector2:
	return set_tile_map_position(get_tile_map_position(pos))

static func get_tile_map_position(pos: Vector2) -> Vector2:
	return ((pos - TILE_OFFSET) / TILE_SIZE).round()

static func set_tile_map_position(pos: Vector2) -> Vector2:
	return pos * TILE_SIZE + TILE_OFFSET
