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
@export var count: int = 1
@export var show_count: bool = false
@export var snap: bool = true


static func get_colour_value(colour: CheeseColour) -> Color:
	if colour == CheeseColour.YELLOW:
		return Color.from_string("#c4a81a", Color.BLACK)
	elif colour == CheeseColour.GREEN:
		return Color.from_string("#6abe30", Color.BLACK)
	elif colour == CheeseColour.RED:
		return Color.from_string("#ac3232", Color.BLACK)
	elif colour == CheeseColour.ORANGE:
		return Color.from_string("#d25012", Color.BLACK)
	elif colour == CheeseColour.BLUE:
		return Color.from_string("#5b6ee1", Color.BLACK)
		
	return Color.BLACK

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if snap:
		self.position = SnapUtils.snap_to_grid(self.position)
	$AnimatedSprite2D.frame = colour
	$AnimatedSprite2D/CountLabels.visible = show_count
	if show_count:
		$AnimatedSprite2D/CountLabels.text = str(count)
	
