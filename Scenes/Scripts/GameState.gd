extends Node

var grv = 2000.0 #global relative velocity
var first_game = true
var is_alive = false

var reset = false
var global_iframes = 0.25

var hp = 3
var score = 0

var can_score = false

func _process(delta):
	if hp <= 0:
		is_alive = false
	if is_alive:
		grv = 200
	else:
		grv = 0
	
	if can_score && is_alive:
		_add_score()
	
func _add_score():
	can_score = false
	score += 100
	get_tree().create_timer(2).timeout.connect(_on_score_timeout)

func _on_score_timeout():
	can_score = true
