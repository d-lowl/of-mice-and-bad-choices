@tool
extends Node2D
class_name Cheese

enum CheeseColour {
	YELLOW = 0,
	GREEN = 1,
	RED = 2,
	ORANGE = 3,
	BLUE = 4
}
@export var colour: CheeseColour = CheeseColour.YELLOW

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = SnapUtils.snap_to_grid(self.position)
	$AnimatedSprite2D.frame = colour
