#File defines the behaviour of the alien enemy
extends Area2D

const FIRERATE = 1.3 #defines alien firerate, could change value to implement difficulties

var can_fire = true #ie, it's not dead
var hit = false
var laser_scene = preload("res://Scenes/laser.tscn")
var rng = randi_range(1,50) #chance variable

func _ready():
	body_entered.connect(_on_body_entered)
	body_entered.connect(_on_shot)

func _process(delta):
		if can_fire && !hit && GameState.is_alive:
			fire()

func _on_body_entered(body):
	if body.is_in_group("player") && !hit:
		visible = false
		hit = true 
		GameState.score += 100
		$hit.play()
		if rng == 50:
			$scream.play() #basically 1/50 chance to play scream sound upon death

func _on_shot(body):
	if body.is_in_group("bullet") && !hit:
		visible = false
		hit = true
		GameState.score += 100
		body.queue_free()
		$hit.play()

func fire():
	can_fire = false
	$laser.play()
	var laser=laser_scene.instantiate()
	laser.position = $Node2D.global_position
	get_tree().current_scene.add_child(laser)
	get_tree().create_timer(FIRERATE).timeout.connect(func(): can_fire = true)
