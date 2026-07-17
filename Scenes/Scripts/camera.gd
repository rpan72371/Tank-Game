extends CharacterBody2D

func _physics_process(delta: float) -> void:
	velocity.x = GameState.grv
	move_and_slide()

func play_start():
	$start.play()
