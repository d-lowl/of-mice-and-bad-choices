extends Node2D

signal mice_spawned(n: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_mice()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_mice():
	var mouse_scene = load("res://mouse/mouse.tscn")
	var cacti_locations = $TileMap.get_used_cells_by_id(1, 1, Vector2(0,0))
	for location in cacti_locations:
		var mouse = mouse_scene.instantiate()
		mouse.set_tile_map_position(location)
		self.add_child(mouse)
