class_name Shields
extends Powerup

var timer: Timer

func activate():
	GameState.shield_active = true

	if timer == null:
		timer = Timer.new()
		timer.one_shot = true
		timer.timeout.connect(func(): GameState.shield_active = false)
		add_child(timer)
	timer.start(5)

func _process(_delta):
	if timer == null:
		return
	if timer.time_left <= 1 && timer.time_left > 0:
		GameState.shield_blinking = true
	else:
		GameState.shield_blinking = false
