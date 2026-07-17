extends Sprite2D

const ROTATION = 8.0
const FIRERATE = 0.5

var bullet_path=preload("res://Scenes/bullet.tscn")
var can_fire = true;

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			rotation -= deg_to_rad(ROTATION)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			rotation += deg_to_rad(ROTATION)

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && can_fire && !GameState.lasers_active:
		fire()
		can_fire = false
		get_tree().create_timer(FIRERATE).timeout.connect(_on_cooldown_done)
	elif GameState.lasers_active && can_fire:
		fire()
		can_fire = false
		get_tree().create_timer(FIRERATE/4).timeout.connect(_on_cooldown_done)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) && GameState.held_powerup != null:
		GameState.use_powerup(self)
		
func _on_cooldown_done():
	can_fire = true

func fire():
	var bullet=bullet_path.instantiate()
	bullet.dir=rotation
	bullet.pos=$Node2D.global_position
	bullet.rota=rotation
	$gun.play()
	get_tree().current_scene.add_child(bullet)
