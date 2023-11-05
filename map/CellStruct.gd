extends RefCounted
class_name CellStruct

@export var influence_hint: InfluenceHint = null

@export var cheese_entity: Cheese = null

@export var cheese_influence = {
	Cheese.CheeseColour.YELLOW: 0,
	Cheese.CheeseColour.GREEN: 0,
	Cheese.CheeseColour.RED: 0,
	Cheese.CheeseColour.ORANGE: 0,
	Cheese.CheeseColour.BLUE: 0,
}

@export var see_elder: bool = false

@export var is_path: bool = false
@export var is_spawn: bool = false

func _init():
	self.influence_hint = load("res://ui/influence_hint.tscn").instantiate() as InfluenceHint
	self.influence_hint.update(cheese_influence)
	self.influence_hint.set_elder(false)

func get_colour() -> Cheese.CheeseColour:
	if cheese_entity != null:
		return cheese_entity.colour
	return 0  # should not be used anyway

func has_cheese() -> bool:
	return cheese_entity != null and cheese_entity.count > 0
	
func has_influence() -> bool:
	for colour in cheese_influence:
		if cheese_influence[colour] > 0:
			return true
			
	return false

func can_place_cheese(colour: Cheese.CheeseColour) -> bool:
	return (
		self.is_path and  # can only place cheese on paths
		not self.is_spawn and # cannot place on spawn
		((not has_cheese()) or get_colour() == colour)
	)

func add_cheese(colour: Cheese.CheeseColour):
	if can_place_cheese(colour):
		if not has_cheese():
			var cheese_scene = load("res://cheese/Cheese.tscn")
			cheese_entity = cheese_scene.instantiate()
			cheese_entity.colour = colour
			cheese_entity.add_to_group("cheese")
		else:
			cheese_entity.count += 1
		return cheese_entity
		
func remove_cheese():
	if has_cheese() and not self.is_spawn:
		cheese_entity.count -= 1
		if cheese_entity.count <= 0:
			cheese_entity.remove_from_group("cheese")
			cheese_entity.queue_free()
			cheese_entity = null

func mark_elder():
	see_elder = true
	influence_hint.set_elder(true)
	
func update_hint():
	influence_hint.update(cheese_influence)

func is_priority_colour(interest_colour: Cheese.CheeseColour):
	if not has_influence():
		return false
		
	var influence = cheese_influence[interest_colour]
	for colour in cheese_influence:
		if colour == interest_colour:
			continue
		if cheese_influence[colour] >= influence:
			return false
	return true
