extends Node2D

signal mice_spawned(n: int)

const FLOOR_TILE = Vector2i(0, 0)

var grid: Array[Array] = []  # Array[Array[CellStruct]

func initialise_grid(map: TileMap):
	grid = []
	var rect: Rect2i = map.get_used_rect()
	for x in range(rect.size.x):
		grid.append([])
		for y in range(rect.size.y):
			grid[x].append(CellStruct.new())
			var tile: Vector2i = map.get_cell_atlas_coords(0, Vector2i(x, y))
			(grid[x][y] as CellStruct).is_path = tile == FLOOR_TILE


var map: TileMap

func get_cell(location: Vector2) -> CellStruct:
	return (self.grid[location.x][location.y] as CellStruct)

func can_place_cheese(location: Vector2, colour: Cheese.CheeseColour) -> bool:
	return get_cell(location).can_place_cheese(colour)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.map = find_map()
	assert(self.map != null)
	initialise_grid(self.map)
#	spawn_mice()
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


func add_cheese(location: Vector2, colour: Cheese.CheeseColour):
	var cheese_scene = load("res://cheese/Cheese.tscn")
	var cheese: Cheese = cheese_scene.instantiate()
	cheese.colour = colour
	cheese.position = SnapUtils.set_tile_map_position(location)
	cheese.add_to_group("cheese")
	add_child(cheese)
