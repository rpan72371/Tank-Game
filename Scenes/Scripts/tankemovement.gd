extends CharacterBody2D

const BODY_ROTATION = 20
const SIDESPEED = 500.0
var min_y = 162.0
var max_y = 864.0
var alive_status = false
var last_health = 0
var blinking = false

func _ready():
	$pickup.add_to_group("pickup")

func _process(_delta):
	if alive_status && !GameState.is_alive:
		die()
	
	if last_health > GameState.hp:
		$damage.play()
	
	last_health = GameState.hp
	
	if GameState.iframe && !blinking:
		blinking = true
		blink_off()
		get_tree().create_timer(0.05).timeout.connect(blink_on)
		get_tree().create_timer(0.225).timeout.connect(func(): blinking = false)
	
	alive_status = GameState.is_alive

func blink_off():
	$Head.modulate.a = 0.25
	$Body.modulate.a = 0.25

func blink_on():
	$Head.modulate.a = 1
	$Body.modulate.a = 1

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

	# horizontal autoscroll through move_and_slide; keep y out of it
	velocity.x = GameState.grv
	velocity.y = 0
	move_and_slide()

	# vertical: clamp the TARGET before assigning, so it can never overshoot
	position.y = clamp(position.y + dir_y * SIDESPEED * delta, min_y, max_y)

func die():
	GameState.end_run()
	GameState.save_data()
	GameState.load_data()
