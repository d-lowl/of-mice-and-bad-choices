extends Node2D

signal level_complete

@export var is_playing: bool = false

const FLOOR_TILE = Vector2i(0, 0)
const CACTUS_TILE = Vector2i(0, 0)

var mice_left: int = 0
var grid: Array[Array] = []  # Array[Array[CellStruct]
var astar: AStarGrid2D

func initialise_grid(map: TileMap):
	grid = []
	var rect: Rect2i = map.get_used_rect()
	astar = AStarGrid2D.new()
	astar.region = rect
	astar.cell_size = Vector2(1, 1)
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for x in range(rect.size.x):
		grid.append([])
		for y in range(rect.size.y):
			grid[x].append(CellStruct.new())
			var tile: Vector2i = map.get_cell_atlas_coords(0, Vector2i(x, y))
			var item_tile: Vector2i = map.get_cell_atlas_coords(1, Vector2i(x, y))
			var cell = (grid[x][y] as CellStruct)
			cell.is_path = tile == FLOOR_TILE
			cell.is_spawn = item_tile == CACTUS_TILE
			map.add_child(cell.influence_hint)
			cell.influence_hint.position = SnapUtils.set_tile_map_position(Vector2(x, y)) - Vector2(56/2, 56/2)
			astar.set_point_solid(Vector2i(x, y), not cell.is_path)
			
	recalculate_influence()	


var map: Level

func get_cell(location: Vector2i) -> CellStruct:
	var x: int = int(location.x)
	var y: int = int(location.y)
	if x < 0 or y < 0:
		return null
	elif x < self.grid.size() and y < self.grid[x].size():
		return (self.grid[x][y] as CellStruct)
	else:
		return null

func can_place_cheese(location: Vector2, colour: Cheese.CheeseColour) -> bool:
	if is_playing:
		return false
	var cell = get_cell(location)
	if cell != null:
		return cell.can_place_cheese(colour)
	else:
		return false


func add_cheese(location: Vector2, colour: Cheese.CheeseColour) -> bool:
	var cell: CellStruct = get_cell(location)
	if cell != null:
		var cheese: Cheese = cell.add_cheese(colour)
		if cheese != null:
			if not cheese.is_inside_tree():
				cheese.position = SnapUtils.set_tile_map_position(location)
				self.map.add_child(cheese)
			recalculate_influence()
			return true
	return false

func remove_cheese(location: Vector2) -> Cheese.CheeseColour:
	var cell: CellStruct = get_cell(location)
	if cell != null:
		var removed = cell.remove_cheese()
		if removed != Cheese.CheeseColour.NONE:
			recalculate_influence()
			return removed
	return Cheese.CheeseColour.NONE
		
		
func recalculate_influence():
	var cheese_nodes: Array[Node] = get_tree().get_nodes_in_group("cheese")
	
	var rect: Rect2i = map.get_used_rect()
	for x in range(rect.size.x):
		for y in range(rect.size.y):
			var cell: CellStruct = grid[x][y]
			# Clear
			for colour in cell.cheese_influence:
				cell.cheese_influence[colour] = 0
				
			for cheese in cheese_nodes:
				if cheese is Cheese:
					var cheese_location = SnapUtils.get_tile_map_position(cheese.position)
					var distance = abs(x - cheese_location.x) + abs(y - cheese_location.y)
					if distance <= cheese.count:
						cell.cheese_influence[cheese.colour] += cheese.count
			
			cell.update_hint()
			
			
func find_max_influence(position: Vector2, colour: Cheese.CheeseColour) -> Vector2:
	var chosen_position = Vector2.ZERO
	var max_influence = 0
	var cheese_nodes: Array[Node] = get_tree().get_nodes_in_group("cheese")
	for cheese in cheese_nodes:
		if cheese is Cheese:
			var cheese_location = SnapUtils.get_tile_map_position(cheese.position)
			var distance = abs(position.x - cheese_location.x) + abs(position.y - cheese_location.y)
			if distance <= cheese.count and cheese.count > max_influence:
				max_influence = cheese.count
				chosen_position = cheese_location
	return chosen_position

func load_level(level_scene: PackedScene):
	for cheese in get_tree().get_nodes_in_group("cheese"):
		cheese.remove_from_group("cheese")  # To prevent leaking to the next level
	for child in get_children():
		if child is Timer:
			continue
		child.queue_free()
	var level: Level = level_scene.instantiate() as Level
	add_child(level)
	self.map = level
	initialise_grid(self.map)
	mark_elder()
	show_hints(false)
	reset()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	self.map = find_map()
#	assert(self.map != null)
#	initialise_grid(self.map)
#	mark_elder()
#	show_hints(false)
#	reset()


func play():
	is_playing = true
	
func reset():
	is_playing = false
	var mice: Array[Node] = get_tree().get_nodes_in_group("young_mouse")
	for mouse in mice:
		if mouse is Mouse:
			mouse.reset()
	mice_left = mice.size()


func find_map() -> TileMap:
	for child in get_children():
		if child is TileMap:
			return child
			
	return null
	
	
func mark_elder():
	var elder_mouse: Mouse = self.map.get_node("ElderMouse")
	if elder_mouse != null:
		var elder_mouse_location = SnapUtils.get_tile_map_position(elder_mouse.position)
		# Look +x
		var x: int = elder_mouse_location.x + 1
		var cell: CellStruct = get_cell(Vector2i(x, elder_mouse_location.y))
		while cell != null and cell.is_path:
			cell.mark_elder()
			x += 1
			cell = get_cell(Vector2i(x, elder_mouse_location.y))
			
func show_hints(visible: bool):
	var hints: Array[Node] = get_tree().get_nodes_in_group("ui_hints")
	for hint in hints:
		hint.visible = visible
		
func move_mice():
	var mice: Array[Node] = get_tree().get_nodes_in_group("young_mouse")
	var moved = false
	for mouse in mice:
		if mouse is Mouse and mouse.visible:
			moved = true
			move_mouse(mouse)
			
	$StepTimer/TickTockAudio.play()	
	if not moved:
		is_playing = false
		emit_signal("level_complete")

func move_mouse(mouse: Mouse):
	var mouse_location = SnapUtils.get_tile_map_position(mouse.position)
	if mouse_location.x <= 2:
		mouse.visible = false
		mice_left -= 1
		return
		
	var cell = get_cell(mouse_location)
	
	if cell.see_elder:
		if cell.has_influence() and not cell.is_priority_colour(mouse.cheese_preference):
			mouse.set_crying(true)
			return
		mouse_location.x -= 1
		mouse.position = SnapUtils.set_tile_map_position(mouse_location)
		mouse.set_crying(false)
	elif cell.is_priority_colour(mouse.cheese_preference):
		var target = find_max_influence(mouse_location, mouse.cheese_preference)
		var path = astar.get_id_path(mouse_location, target)
		if path.size() > 1:
			mouse.position = SnapUtils.set_tile_map_position(path[1])
			mouse.set_crying(false)
		else:
			mouse.set_crying(true)
		

func _on_step_timer_timeout():
	if is_playing:
		move_mice()
