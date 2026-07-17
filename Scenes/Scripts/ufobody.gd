extends Sprite2D

const ROTATION = 0.8
var uptime = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation -= deg_to_rad(ROTATION)
