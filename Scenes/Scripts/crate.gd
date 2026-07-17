extends Area2D

var hit = false
var diamond = false
var heart = false
var shields = false
var lasers = false
var collected = false
var powerup = false

func _ready():
	var rot = deg_to_rad(randi_range(0,360))
	body_entered.connect(_on_body_entered)
	body_entered.connect(_on_shot)
	$powerup.area_entered.connect(_on_powerup_collected)
	$crate.rotation = rot
	$CollisionShape2D.rotation = rot
	
func _on_body_entered(body):
	if body.is_in_group("player") && !hit && !GameState.iframe:
		GameState.take_damage()
		$powerup._toggle_visiblity()
		$crate.visible = false
		hit = true 

func _on_shot(body):
	if ((body.is_in_group("bullet")) || (body.is_in_group("player") && GameState.shield_active)) && !hit:
		$crate.visible = false
		if randi_range(1,25) >= 24:
			powerup = true
			match randi_range(1,4):
				1:	
					$powerup.use_powerup(1)
					diamond = true
				2:
					$powerup.use_powerup(2)
					heart = true
				3:
					$powerup.use_powerup(3)
					shields = true
				4:
					$powerup.use_powerup(4)
					lasers = true
		$hit.play()
		hit = true
		GameState.score += 10
		if body.is_in_group("bullet"):
			body.queue_free()

func _on_powerup_collected(body):
	if body.is_in_group("pickup") && hit && !collected && powerup:
		if diamond:
			GameState.score += 1500
		elif heart:
			if GameState.hp == 3:
				GameState.score += 500
			else: 
				GameState.score += 200
				GameState.hp += 1
		elif shields:
			GameState.shield_pickup = true
			GameState.score += 200
		elif lasers:
			GameState.lasers_pickup = true
			GameState.score += 200
		collected = true
		$pickup.play()
		$powerup._toggle_visiblity()
