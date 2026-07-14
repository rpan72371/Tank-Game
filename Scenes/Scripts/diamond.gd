extends Area2D

var diamond = preload("res://textures/diamond.png")
var heart = preload("res://textures/life.png")

func _toggle_visiblity():
	$poweruppng.visible = !visible

func use_powerup(type):
	if type == 1:
		$poweruppng.texture = diamond
		$poweruppng.scale = Vector2(0.5, 0.5)
	else:
		$poweruppng.texture = heart
		$poweruppng.scale = Vector2(1.5,1.5)
		
