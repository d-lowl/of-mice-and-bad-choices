extends RefCounted
class_name CellStruct

@export var cheese_count = {
	Cheese.CheeseColour.YELLOW: 0,
	Cheese.CheeseColour.GREEN: 0,
	Cheese.CheeseColour.RED: 0,
	Cheese.CheeseColour.ORANGE: 0,
	Cheese.CheeseColour.BLUE: 0,
}

@export var cheese_influence = {
	Cheese.CheeseColour.YELLOW: 0,
	Cheese.CheeseColour.GREEN: 0,
	Cheese.CheeseColour.RED: 0,
	Cheese.CheeseColour.ORANGE: 0,
	Cheese.CheeseColour.BLUE: 0,
}

@export var is_path: bool = false

func has_cheese() -> bool:
	for colour in cheese_count:
		if cheese_count[colour] > 0:
			return true
			
	return false

func can_place_cheese(colour: Cheese.CheeseColour) -> bool:
	return (
		self.is_path and  # can only place cheese on paths
		(
			(not has_cheese()) or 
			cheese_count[colour] > 0
		)
	)
