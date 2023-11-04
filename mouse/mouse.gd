@tool
extends Node2D
class_name Mouse


enum MouseType {
	Young, 
	YoungCrying, 
	Elder
}
@export_enum("young", "young_crying", "elder") var mouse_type: String = "young"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.animation = mouse_type
	$AnimatedSprite2D.flip_h = not self.is_elder()
	self.position = SnapUtils.snap_to_grid(self.position)

func is_elder():
	return mouse_type == "elder"
