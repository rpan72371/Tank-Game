class_name Shields
extends Powerup

func activate():
	GameState.shield_active = true
	get_tree().create_timer(4).timeout.connect(func(): GameState.shield_active = false)
