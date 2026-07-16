extends AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameState.is_alive:
		play("default")
	else:
		stop()
