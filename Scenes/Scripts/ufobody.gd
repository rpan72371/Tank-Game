extends Sprite2D

const ROTATION = 0.8
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation -= deg_to_rad(ROTATION)
