extends Area2D

var diamond = preload("res://textures/diamond.png")
var heart = preload("res://textures/life.png")

func _toggle_visiblity():
	$poweruppng.visible = !visible

func use_powerup(type):
	if type == 1:
		$poweruppng.texture = diamond
		$poweruppng.scale = Vector2(6.66666, 6.66666)
	else:
		$poweruppng.texture = heart
		$poweruppng.scale = Vector2(6.66666,6.66666)
		
