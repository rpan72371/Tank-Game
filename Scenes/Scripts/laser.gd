extends CharacterBody2D
const speed = -800

func _ready():
	get_tree().create_timer(2).timeout.connect(queue_free)
	$Area2D.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	velocity.x = speed
	move_and_slide()

func _on_body_entered(body):
	if body.is_in_group("player") && !GameState.iframe:
		GameState.take_damage()
	queue_free()
	
