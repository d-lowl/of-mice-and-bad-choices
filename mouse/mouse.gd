@tool
extends Node2D

const TILE_SIZE = 64
const TILE_OFFSET = Vector2(TILE_SIZE / 2, TILE_SIZE / 2)


enum MouseType {
	Young, 
	YoungCrying, 
	Elder
}
@export_enum("young", "young_crying", "elder") var mouse_type: String = "young"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.animation = mouse_type
	$AnimatedSprite2D.flip_h = not self.is_elder()
	snap_to_grid()
	
func snap_to_grid():
	set_tile_map_position(get_tile_map_position())

func is_elder():
	return mouse_type == "elder"
	
	
func get_tile_map_position() -> Vector2:
	return ((self.position - TILE_OFFSET) / TILE_SIZE).round()

func set_tile_map_position(pos: Vector2):
	self.position = pos * TILE_SIZE + TILE_OFFSET
