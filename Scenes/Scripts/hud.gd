extends CanvasLayer

@onready var hearts = [$HealthContainer/Heart1, $HealthContainer/Heart2, $HealthContainer/Heart3]
@onready var score_label = $Score

const shield = preload("res://textures/shields.png")
const laser = preload("res://textures/lasers.png")

func _process(_delta):
	#Show hp, max 3 
	for i in hearts.size():
		hearts[i].visible = i < GameState.hp

	score_label.text = "SCORE:%06d" % GameState.score
	
	#display powerup if held
	match GameState.held_powerup:
		GameState.shields_powerup:
			$powerup.texture = shield
		GameState.lasers_powerup:
			$powerup.texture = laser
		_: 
			$powerup.texture = null
	if GameState.held_powerup != null:
		$powerup.scale = Vector2(0.8, 0.8)
	
