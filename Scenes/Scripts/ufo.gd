extends CharacterBody2D

var uptime = 0.0
var hit = false
var iframe = false
var vert = 0
var rng = randi_range(0,1) 
# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D2.body_entered.connect(_on_hitbox_entered)
	$Area2D.body_entered.connect(_on_hurtbox_entered)
	z_index = 10
	
func _physics_process(delta: float) -> void:
	velocity.x = GameState.grv * 1.75


	velocity.y = vert
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	uptime += delta
	if rng:
		vert = 350*sin(uptime*2.5) * GameState.grv/GameState.initial_velocity
	else:
		vert = -350*sin(uptime*2.5) * GameState.grv/GameState.initial_velocity

func _on_hitbox_entered(body):
	if body.is_in_group("bullet") && !hit:
		body.queue_free()      # destroy the bullet
		hit = true
		$ufohead.visible = false
		$ufobody.visible = false
		GameState.score += 100

func _on_hurtbox_entered(body):
	if body.is_in_group("player") && !iframe && !hit:
		iframe = true
		GameState.hp -= 1
		get_tree().create_timer(GameState.global_iframes).timeout.connect(end_iframe)
		
func end_iframe():
	iframe = false
