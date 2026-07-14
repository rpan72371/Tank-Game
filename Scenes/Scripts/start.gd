extends Area2D

func _ready():
	if GameState.first_game:
		$Sprite2D.texture = load("res://textures/start.png")
		GameState.first_game = false
	else:
		$Sprite2D.texture = load("res://textures/restart.png")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("bullet"):
		GameState.reset = true      # decrement health
		queue_free()           # despawn the start button instantly
	get_tree().create_timer(2).timeout.connect(GameState._on_score_timeout)
