extends CharacterBody2D

const BODY_ROTATION = 20
const SIDESPEED = 310.0
@export var min_y = 162.0
@export var max_y = 864.0

func _ready():
	$pickup.add_to_group("pickup")
	
func _physics_process(delta: float) -> void:
	# decide vertical direction from held keys
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
