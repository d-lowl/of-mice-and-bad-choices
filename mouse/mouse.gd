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

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	spawn_position = position


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
	
