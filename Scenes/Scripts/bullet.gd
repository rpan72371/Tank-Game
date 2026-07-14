extends CharacterBody2D
const speed = 1200

var pos: Vector2
var rota: float 
var dir: float

func _ready():
	add_to_group("bullet")
	global_position=pos
	global_rotation=rota
	get_tree().create_timer(1.5).timeout.connect(queue_free)

func _physics_process(delta):
	velocity=Vector2(speed,0).rotated(dir)
	move_and_slide()
	
