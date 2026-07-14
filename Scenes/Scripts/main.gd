extends Node2D

var start_button = preload("res://Scenes/start.tscn")

var tank_start: Vector2
var camera_start: Vector2

var alien_scene = preload("res://Scenes/alien.tscn")
var ufo_scene = preload("res://Scenes/ufo.tscn")
var rock_scene = preload("res://Scenes/rock.tscn")
var crate_scene = preload("res://Scenes/crate.tscn")

var obstacles: Array = []
var enemies: Array = []

var enemy_interval: float = 4.0 # seconds between enemies
var obs_interval: float = 2.0   # seconds between rocks
var min_y = 216.0           # top of play area
var max_y = 864.0          # bottom of play area
var spawn_x = 1970.0       # where rocks first appear (off right edge)

var frame_counter = 0
var time_since_obs = 0.0
var time_since_enemy = 0.0
var next_obs = 1.5
var next_enemy = 1.5
var scroll_x = 0.0
var reset_pending = false

func _ready():
	tank_start = $Tank.global_position
	camera_start = $CameraFollower.global_position
	
func _process(delta):
	if GameState.is_alive: 
		scroll_x += 200 * delta
		var rng = randi_range(1, 10)
		time_since_obs += delta 
		time_since_enemy += delta
		if time_since_obs >= next_obs:# obstacle spawning logic
			time_since_obs = 0.0
			if scroll_x <= 25000:
				next_obs = obs_interval - floor(scroll_x/5000)/5
			else:
				next_obs = 1
			if rng > 8:
				generate_obs(true)
			else:
				generate_obs(false) 
		if time_since_enemy >= next_enemy:
			time_since_enemy = 0.0
			if scroll_x <= 30000:
				next_enemy = enemy_interval - floor(scroll_x/5000)/5
			if rng > 7:
				generate_enemy()

	if not GameState.is_alive and not reset_pending: # trigger reset flag
		reset_pending = true
		var start = start_button.instantiate()	
		start.global_position = $CameraFollower.position
		add_child(start)
	
	if GameState.reset: # reset game
		GameState.reset = false
		reset_game()

	if frame_counter % 500 != 0:
		return          
	else:
		frame_counter = 0
		check_offscreen()

func check_offscreen():
	while true:
		if not obstacles.is_empty():
			if not is_instance_valid(obstacles[0]):
				obstacles[0].queue_free()
				obstacles.pop_front()
				continue
			if obstacles[0].global_position.x < $CameraFollower.position.x - 1000:
				obstacles[0].queue_free()
				obstacles.pop_front()
				continue
				
		if !enemies.is_empty():
			if not is_instance_valid(enemies[0]):
				enemies.pop_front()
				continue
			if enemies[0].global_position.x > $CameraFollower.position.x + 1000:
				enemies[0].queue_free()
				enemies.pop_front()
				continue
		return

func generate_obs(spawn_two):
	if spawn_two == false:
		var y = randf_range(min_y, max_y)
		spawn_obstacle_at(y)
	else:
		var mid = (min_y + max_y) / 2
		var gap = 60.0        # minimum separation buffer
		var y1 = randf_range(min_y, mid - gap / 2)
		var y2 = randf_range(mid + gap / 2, max_y)
		spawn_obstacle_at(y1)
		spawn_obstacle_at(y2)

func spawn_obstacle_at(y: float):
	var rng = randi_range(1,10)
	var obs = crate_scene.instantiate()
	if rng <= 3: 
		obs = rock_scene.instantiate()
	elif rng >= 9:
		obs = alien_scene.instantiate()
	obs.global_position = Vector2(scroll_x + spawn_x, y)
	add_child(obs)
	obstacles.append(obs)

func generate_enemy():
	var enemy = ufo_scene.instantiate()
	var spawn_y = randf_range(min_y, max_y)
	enemy.global_position = Vector2(scroll_x - spawn_x, spawn_y)
	add_child(enemy)
	enemies.append(enemy)
	
func reset_game():
	$Tank.global_position = tank_start
	$CameraFollower.global_position = camera_start
	scroll_x = 0.0
	time_since_obs = 0.0
	
	for rock in obstacles:
		if is_instance_valid(rock):
			rock.queue_free()
	obstacles.clear()
	
	GameState.score = 0
	GameState.hp = 3
	GameState.is_alive = true
	GameState.can_score = false
	reset_pending = false
	
	

	
