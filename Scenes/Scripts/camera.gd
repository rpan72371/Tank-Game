extends CharacterBody2D

func _ready():
	$AudioListener2D.make_current()

func _process(_delta: float) -> void:
	if GameState.vertical_display:
		$AudioListener2D.rotation = deg_to_rad(90)
	else:
		$AudioListener2D.rotation = deg_to_rad(0)

func _physics_process(_delta: float) -> void:
	velocity.x = GameState.grv
	move_and_slide()

func play_start():
	$start.play()
