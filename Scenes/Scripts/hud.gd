extends CanvasLayer

@onready var hearts = [$HealthContainer/Heart1, $HealthContainer/Heart2, $HealthContainer/Heart3]
@onready var score_label = $Score
@onready var highscore_label = $Highscore

const shield = preload("res://textures/shields.png")
const laser = preload("res://textures/lasers.png")

func _process(delta):
	# hearts: show one per remaining HP
	for i in hearts.size():
		hearts[i].visible = i < GameState.hp

	# score: arcade-style zero-padded
	score_label.text = "SCORE:%06d" % GameState.score

	match GameState.held_powerup:
		GameState.shields_powerup:
			$powerup.texture = shield
		GameState.lasers_powerup:
			$powerup.texture = laser
		_: 
			$powerup.texture = null
	if GameState.held_powerup != null:
		$powerup.scale = Vector2(0.8, 0.8)
	
