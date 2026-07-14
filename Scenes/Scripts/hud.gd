extends CanvasLayer

@onready var hearts = [$HealthContainer/Heart1, $HealthContainer/Heart2, $HealthContainer/Heart3]
@onready var score_label = $Score

func _process(delta):
	# hearts: show one per remaining HP
	for i in hearts.size():
		hearts[i].visible = i < GameState.hp

	# score: arcade-style zero-padded
	score_label.text = "SCORE:%06d" % GameState.score
