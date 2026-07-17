class_name Powerup
extends Node

var held = false
var active = false

func activate() -> void:
	push_error("activate() must be overridden in subclass")
	assert(false, "this is an abstract class")
