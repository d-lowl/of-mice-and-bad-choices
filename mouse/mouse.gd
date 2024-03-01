@tool
extends Node2D
class_name Mouse


enum MouseType {
	Young, 
	YoungCrying, 
	Elder
}
@export_enum("young", "young_crying", "elder") var mouse_type: String = "young"
@export var cheese_preference: Cheese.CheeseColour = Cheese.CheeseColour.YELLOW
@export var spawn_position: Vector2
@export var last_move: Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	spawn_position = position
	
	
func get_grid_pos() -> Vector2:
	return SnapUtils.get_tile_map_position(self.position)
	
	
func set_grid_pos(grid_pos: Vector2):
	self.position = SnapUtils.set_tile_map_position(grid_pos)
	
	
func move_to(grid_pos: Vector2):
	self.last_move = (grid_pos - self.get_grid_pos()).normalized()
	self.set_grid_pos(grid_pos)
	
func move(grid_direction: Vector2):
	self.last_move = grid_direction
	self.set_grid_pos(self.get_grid_pos() + grid_direction)

func get_move_preference() -> Array[Vector2]:
	return [
		self.last_move,  # 1st, want to continue in the same direction
		Vector2(
			self.last_move.y,
			-self.last_move.x,
		), # 2nd, try turning left
		Vector2(
			-self.last_move.y,
			self.last_move.x,
		), # 3rd, try turning right
		Vector2(
			-self.last_move.x,
			-self.last_move.y,
		)  # last, turn around
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.animation = mouse_type
	$AnimatedSprite2D.flip_h = not self.is_elder()
	self.position = SnapUtils.snap_to_grid(self.position)
	if not is_elder() and cheese_preference != null:
		$Cheese.visible = true
		$Cheese.colour = cheese_preference
	else:
		$Cheese.visible = false
		
func is_elder():
	return mouse_type == "elder"
	
	
func reset():
	self.position = SnapUtils.snap_to_grid(spawn_position)
	self.visible = true
	self.mouse_type = "young_crying"
	
	
func set_crying(is_crying: bool):
	if is_crying and mouse_type == "young":
		mouse_type = "young_crying"
	elif not is_crying and mouse_type == "young_crying":
		mouse_type = "young"
