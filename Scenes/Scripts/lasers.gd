class_name Lasers
extends Powerup

var timer: Timer

func activate():
	GameState.lasers_active = true

	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(func(): GameState.lasers_active = false)
		add_child(timer)

	timer.start(6)
	
