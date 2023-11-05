extends Node2D

enum GameState {
	PLACING
}

@export var state = GameState.PLACING
var cheese_cursor_colour: Cheese.CheeseColour = Cheese.CheeseColour.YELLOW

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == GameState.PLACING:
		draw_cheese_cursor()
		


func _on_navigation_step_pressed():
	var mice: Array[Node] = get_tree().get_nodes_in_group("young_mouse")
	for mouse in mice:
		if mouse is Mouse:
			print(mouse)
			


func draw_cheese_cursor():
	var cursor: Cheese = $CheeseCursor
	var grid_position = SnapUtils.get_tile_map_position(get_local_mouse_position())
	if grid_position.x > 2 and $Map.can_place_cheese(grid_position, cheese_cursor_colour):
		cursor.position = SnapUtils.snap_to_grid(get_local_mouse_position())
		
	cursor.colour = cheese_cursor_colour


func _unhandled_key_input(event):
	if event.is_pressed():
		if state == GameState.PLACING:
			if event.keycode == KEY_1:
				cheese_cursor_colour = Cheese.CheeseColour.YELLOW
			elif event.keycode == KEY_2:
				cheese_cursor_colour = Cheese.CheeseColour.GREEN
			elif event.keycode == KEY_3:
				cheese_cursor_colour = Cheese.CheeseColour.RED
			elif event.keycode == KEY_4:
				cheese_cursor_colour = Cheese.CheeseColour.ORANGE
			elif event.keycode == KEY_5:
				cheese_cursor_colour = Cheese.CheeseColour.BLUE

func _unhandled_input(event: InputEvent):
	if state == GameState.PLACING:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				print("Place ", cheese_cursor_colour, SnapUtils.get_tile_map_position($CheeseCursor.position))
				$Map.add_cheese(SnapUtils.get_tile_map_position($CheeseCursor.position), cheese_cursor_colour)

func _on_ui_choose_cheese_colour(colour):
	cheese_cursor_colour = colour
	
	
