extends Node2D

enum GameState {
	PLACING
}

@export var state = GameState.PLACING
var cheese_cursor_colour: Cheese.CheeseColour = Cheese.CheeseColour.YELLOW
@export var level_index: = 0
@export var levels: Array[PackedScene] = []
@export var cheese_inventory = {
	Cheese.CheeseColour.YELLOW: 0,
	Cheese.CheeseColour.GREEN: 0,
	Cheese.CheeseColour.RED: 0,
	Cheese.CheeseColour.ORANGE: 0,
	Cheese.CheeseColour.BLUE: 0,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Map.load_level(levels[level_index])
	cheese_inventory = ($Map.map as Level).cheese_inventory	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == GameState.PLACING:
		draw_cheese_cursor()
	draw_inventory()
	
	
func draw_inventory():
	$CanvasLayer/YellowCheeseButton/Cheese.count = cheese_inventory[Cheese.CheeseColour.YELLOW]
	$CanvasLayer/GreenCheeseButton/Cheese.count = cheese_inventory[Cheese.CheeseColour.GREEN]
	$CanvasLayer/RedCheeseButton/Cheese.count = cheese_inventory[Cheese.CheeseColour.RED]
	$CanvasLayer/OrangeCheeseButton/Cheese.count = cheese_inventory[Cheese.CheeseColour.ORANGE]
	$CanvasLayer/BlueCheeseButton/Cheese.count = cheese_inventory[Cheese.CheeseColour.BLUE]


func _on_navigation_step_pressed():
	if not $Map.is_playing:
		$CanvasLayer/PlayButton.text = "Reset [SPACE]"
		$Map.play()
	else:
		$CanvasLayer/PlayButton.text = "Play [SPACE]"
		$Map.reset()


func draw_cheese_cursor():
	var cursor: Cheese = $CheeseCursor
	var grid_position = SnapUtils.get_tile_map_position(get_local_mouse_position())
	if grid_position.x > 2 and $Map.can_place_cheese(grid_position, cheese_cursor_colour):
		cursor.visible = true
		cursor.position = SnapUtils.snap_to_grid(get_local_mouse_position())
		cursor.colour = cheese_cursor_colour
	else:
		cursor.visible = false
		


func _unhandled_key_input(event):
	if event.keycode == KEY_TAB:
		$Map.show_hints(event.pressed)
			
		
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
		
		if event.keycode == KEY_SPACE:
			_on_navigation_step_pressed()

func add_cheese(position: Vector2, colour: Cheese.CheeseColour):
	if $Map.is_playing:
		return
	if cheese_inventory[colour] <= 0:
		$BadPlayer.play()
		return  # No cheese left
	var placed = $Map.add_cheese(position, colour)
	if placed:
		cheese_inventory[colour] -= 1
		$GoodPlayer.play()
	else:
		$BadPlayer.play()
		
func remove_cheese(position: Vector2):
	if $Map.is_playing:
		return
	var removed = $Map.remove_cheese(position)
	if removed != Cheese.CheeseColour.NONE:
		cheese_inventory[removed] += 1
		$GoodPlayer.play()
	else:
		$BadPlayer.play()
	

func _unhandled_input(event: InputEvent):
	if state == GameState.PLACING:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				add_cheese(SnapUtils.get_tile_map_position(get_local_mouse_position()), cheese_cursor_colour)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				remove_cheese(SnapUtils.get_tile_map_position(get_local_mouse_position()))

func _on_ui_choose_cheese_colour(colour):
	cheese_cursor_colour = colour


func _on_hints_button_button_down():
	$Map.show_hints(true)


func _on_hints_button_button_up():
	$Map.show_hints(false)


func _on_map_level_complete():
	$EndLevelPlayer.play()
	load_next_level()
	
func load_next_level():
	$CanvasLayer/PlayButton.text = "Play [SPACE]"
	level_index += 1
	if level_index >= levels.size():
		$CanvasLayer/FinalePanel.visible = true
		return
	$Map.load_level(levels[level_index])
	$Map.reset()
	cheese_inventory = ($Map.map as Level).cheese_inventory
