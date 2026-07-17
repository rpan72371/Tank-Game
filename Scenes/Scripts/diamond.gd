extends Area2D

var diamond = preload("res://textures/diamond.png")
var heart = preload("res://textures/life.png")
var shields = preload("res://textures/shields.png")
var lasers = preload("res://textures/lasers.png")


func _toggle_visiblity():
	$poweruppng.visible = !visible

func use_powerup(type):
	match type:
		1:
			$poweruppng.texture = diamond
			$poweruppng.scale = Vector2(6.66666, 6.66666)
		2:
			$poweruppng.texture = heart
			$poweruppng.scale = Vector2(6.66666,6.66666)
		3:
			$poweruppng.texture = shields
			$poweruppng.scale = Vector2(6.66666,6.66666)
		_:	
			$poweruppng.texture = lasers
			$poweruppng.scale = Vector2(6.66666,6.66666)
