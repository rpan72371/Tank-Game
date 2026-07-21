extends CharacterBody2D
const BULLET_SPEED = 1700 
const LASER = preload("res://textures/laser.png")

var pos: Vector2
var rota: float 
var dir: float

func _ready():
	if GameState.lasers_active:
		$Sprite2D.texture = LASER

	add_to_group("bullet")
	global_position=pos
	global_rotation=rota
	get_tree().create_timer(1.5).timeout.connect(queue_free)
	
func _physics_process(_delta):
	velocity=Vector2(BULLET_SPEED,0).rotated(dir)
	move_and_slide()
	
