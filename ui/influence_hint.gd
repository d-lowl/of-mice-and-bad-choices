extends Control

class_name InfluenceHint

const COLOUR_MAPPING = {
	Cheese.CheeseColour.YELLOW: "YellowLabel",
	Cheese.CheeseColour.GREEN: "GreenLabel",
	Cheese.CheeseColour.RED: "RedLabel",
	Cheese.CheeseColour.ORANGE: "OrangeLabel",
	Cheese.CheeseColour.BLUE: "BlueLabel",
}

func set_colour(colour: Cheese.CheeseColour, value: int):
	get_node(COLOUR_MAPPING[colour]).text = str(value)
	
func set_elder(value: bool):
	if value:
		$ElderLabel.text = "See!"
	else:
		$ElderLabel.text = ""
		
func update(influence: Dictionary):
	for colour in influence:
		set_colour(colour, influence[colour])
	
