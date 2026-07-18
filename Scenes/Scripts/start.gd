extends Area2D

var hit = false 

func _ready():
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(0.1).timeout.connect(ready)

func ready():
	if GameState.first_game:
		$Label.text = "START"
		GameState.first_game = false
	else:
		$fail.play()
		$Label2.text = "Restart"
	$Label3.text = "HIGHSCORE:%06d" % GameState.high_score
	
func _process(_delta):
	if GameState.vertical_display:
		self.rotation = deg_to_rad(90)
	else: 
		self.rotation = deg_to_rad(0)

func _on_body_entered(body):
	if body.is_in_group("bullet") && !hit:
		GameState.reset = true
		GameState.save_data()
		body.queue_free()
		queue_free()
	get_tree().create_timer(2).timeout.connect(GameState._on_score_timeout)
