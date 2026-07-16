extends Area2D

var hit = false
var diamond = false
var heart = false
var collected = false
var rng = randi_range(1,25)

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
	if body.is_in_group("bullet") && !hit:
		if !(rng >= 24):
			$crate.visible = false
		else:
			if int(randi_range(1,0)) % 2 == 0:
				$crate.visible = false
				$powerup.use_powerup(1)
				diamond = true
			else: 
				$crate.visible = false
				$powerup.use_powerup(2)
				heart = true
		$hit.play()
		hit = true
		GameState.score += 10
		body.queue_free()

func _on_powerup_collected(body):
	if body.is_in_group("pickup") && hit && !collected:
		if diamond:
			GameState.score += 1000
			$pickup.play()
		elif heart:
			if GameState.hp == 3:
				GameState.score += 500
			else: 
				GameState.score += 200
				GameState.hp += 1
			$pickup.play()
		collected = true
		$powerup._toggle_visiblity()
		
