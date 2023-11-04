extends Node2D

signal mice_spawned(n: int)

var map: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	self.map = find_map()
	assert(self.map != null)
	spawn_mice()
	pass # Replace with function body.


func find_map() -> TileMap:
	for child in get_children():
		if child is TileMap:
			return child
			
	return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_mice():
	var mouse_scene = load("res://mouse/mouse.tscn")
	var cacti_locations: Array[Vector2i] = self.map.get_used_cells_by_id(1, 1, Vector2(0,0))
	for location in cacti_locations:
		var mouse: Mouse = mouse_scene.instantiate()
		mouse.position = SnapUtils.set_tile_map_position(location)
		mouse.add_to_group("young_mouse")
		self.add_child(mouse)
		
	emit_signal("mice_spawned", cacti_locations.size())
