extends CanvasLayer

signal choose_cheese_colour(colour: Cheese.CheeseColour)


func _on_green_cheese_pressed():
	emit_signal("choose_cheese_colour", Cheese.CheeseColour.GREEN)


func _on_yellow_cheese_pressed():
	emit_signal("choose_cheese_colour", Cheese.CheeseColour.YELLOW)


func _on_red_cheese_pressed():
	emit_signal("choose_cheese_colour", Cheese.CheeseColour.RED)


func _on_orange_cheese_pressed():
	emit_signal("choose_cheese_colour", Cheese.CheeseColour.ORANGE)


func _on_blue_cheese_pressed():
	emit_signal("choose_cheese_colour", Cheese.CheeseColour.BLUE)
