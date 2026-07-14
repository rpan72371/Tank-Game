extends Area2D

const FIRERATE = 1

var can_fire = true
var hit = false
var laser_scene = preload("res://Scenes/laser.tscn")

func _ready():
	body_entered.connect(_on_body_entered)
	body_entered.connect(_on_shot)

func _process(delta):
		if can_fire && !hit && GameState.is_alive:
			fire()

func _on_body_entered(body):
	if body.is_in_group("player") && !hit:
		GameState.hp -= 1 # decrement health
		visible = false
		hit = true 

func _on_shot(body):
	if body.is_in_group("bullet") && !hit:
		visible = false
		hit = true
		GameState.score += 100
		body.queue_free()

func fire():
	toggle_fire()
	var laser=laser_scene.instantiate()
	laser.position = $Node2D.global_position
	get_tree().current_scene.add_child(laser)
	get_tree().create_timer(FIRERATE).timeout.connect(toggle_fire)
	
func toggle_fire():
	can_fire = !can_fire
