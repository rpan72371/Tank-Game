class_name Lasers
extends Powerup

func activate():
	GameState.lasers_active = true
	get_tree().create_timer(6).timeout.connect(func(): GameState.lasers_active = false)
