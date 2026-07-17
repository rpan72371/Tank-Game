extends Area2D

var hit = false

func _ready():
	body_entered.connect(_on_body_entered)
	$Sprite2D.rotation = deg_to_rad(randi_range(0,360))
	
func _on_body_entered(body):
	if body.is_in_group("player") && !hit && !GameState.iframe:
		GameState.take_damage()
		visible = false
		hit = true 
		if GameState.shield_active:
			$hit.play()
