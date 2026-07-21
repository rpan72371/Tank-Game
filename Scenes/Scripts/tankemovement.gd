extends CharacterBody2D

const BODY_ROTATION = 20
const MIN_Y = 162.0
const MAX_Y = 864.0

#Tracks last hp to track decrease in hp
var last_health = 0 
var alive_status = false

#Powerup specific flags
var tank_blinking = false
var bubble_blinking = false
var axial_speed = 500.0

func _ready():
	$pickup.add_to_group("pickup")

func _process(_delta):
	if alive_status && !GameState.is_alive:
		die()
	
	if last_health > GameState.hp:
		$damage.play()
	
	last_health = GameState.hp
	
	if GameState.iframe && !tank_blinking:
		tank_blinking = true
		blink_tank_off()
		get_tree().create_timer(0.05).timeout.connect(blink_tank_on)
		get_tree().create_timer(0.225).timeout.connect(func(): tank_blinking = false)
	
	alive_status = GameState.is_alive
	if GameState.shield_active:
		$bubble.visible = true
		if !bubble_blinking:
			$bubble.modulate.a = 0.5
	else:
		$bubble.visible = false

	if GameState.shield_blinking && !bubble_blinking:
		bubble_blinking = true
		blink_bubble_off()
		get_tree().create_timer(0.05).timeout.connect(blink_bubble_on)
		get_tree().create_timer(0.225).timeout.connect(func(): bubble_blinking = false)

func blink_tank_off():
	$Head.modulate.a = 0.25
	$Body.modulate.a = 0.25

func blink_tank_on():
	$Head.modulate.a = 1
	$Body.modulate.a = 1

func blink_bubble_off():
	$bubble.modulate.a = 0.1

func blink_bubble_on():
	$bubble.modulate.a = 0.4
	
func _physics_process(delta: float) -> void:
	var dir_y = 0.0
	if Input.is_action_pressed("s") and Input.is_action_pressed("w") or !GameState.is_alive:
		$Body.rotation = deg_to_rad(0)
		dir_y = 0.0
	elif Input.is_action_pressed("s"):
		$Body.rotation = deg_to_rad(BODY_ROTATION)
		dir_y = 1.0
	elif Input.is_action_pressed("w"):
		$Body.rotation = deg_to_rad(-BODY_ROTATION)
		dir_y = -1.0
	else:
		$Body.rotation = deg_to_rad(0)
		dir_y = 0.0

	# Enable left and right motion during free_move active
	var dir_x = 0.0
	if GameState.is_alive && GameState.free_move:
		axial_speed = 275
		if Input.is_action_pressed("d"):
			dir_x = 1.0
		elif Input.is_action_pressed("a"):
			dir_x = -(axial_speed+GameState.initial_velocity)/axial_speed
	else:
		axial_speed = 500
	
	velocity.x = GameState.grv + dir_x * axial_speed
	velocity.y = 0
	move_and_slide()
	
	var cam_x = get_viewport().get_camera_2d().global_position.x
	position.y = clamp(position.y + dir_y * axial_speed * delta, MIN_Y, MAX_Y)
	position.x = clamp(position.x, cam_x - 920, cam_x + 920)
	
func die():
	GameState.end_run()
	GameState.save_data()
	GameState.load_data()
