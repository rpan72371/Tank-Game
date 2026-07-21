extends Sprite2D

const ROTATION = 4
var rotate = true
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	if rotate:
		rotate = false
		rotation -= deg_to_rad(ROTATION)
		get_tree().create_timer(0.0175).timeout.connect(func(): rotate = true)
