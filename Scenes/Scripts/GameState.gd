extends Node

#Game variables
const initial_velocity = 350
const global_iframes = 0.75
var grv = 0
var hp = 3
var first_game = true
var is_alive = false
var can_score = false
var iframe = false
var score = 0
var high_score = 0
var reset = false
var acceleration = 0.0

const SAVE_PATH = "user://savedata.save"

#Powerup variables
const shields_powerup = "res://Scenes/Scripts/shields.gd"
const lasers_powerup = "res://Scenes/Scripts/lasers.gd"
var held_powerup = null
var shield_active = false
var lasers_active = false
var active_shield: Shields = null
var active_lasers: Lasers = null
var shield_pickup = false
var lasers_pickup = false
var shield_blinking = false

#Toggle specific variables
var crt_visible = false
var crt_curved = true 
var free_move = false
var vertical_display = false

func _ready():
	load_data()

func _process(delta):
	acceleration += delta
	if hp <= 0:
		is_alive = false
		grv = 0
	
	if can_score and is_alive:
		_add_score()
	
	if shield_pickup == true:
		shield_pickup = false
		held_powerup = shields_powerup
	
	if lasers_pickup == true:
		lasers_pickup = false
		held_powerup = lasers_powerup

func _add_score():
	can_score = false
	score += 100
	get_tree().create_timer(2).timeout.connect(_on_score_timeout)

func _on_score_timeout():
	can_score = true

# call this when the player dies (before resetting score)
func end_run():
	if score > high_score:
		high_score = score
		save_data()

func take_damage():
	if !shield_active && is_alive:
		iframe = true
		hp -= 1
		acceleration = 0
		get_tree().create_timer(global_iframes).timeout.connect(func(): iframe = false)

func use_powerup(holder: Node) -> void:
	if held_powerup == null:
		return

	if held_powerup == shields_powerup:
		if active_shield == null:
			active_shield = Shields.new()
			holder.add_child(active_shield)
		active_shield.activate()  #Reuses the same timer, restarts it

	elif held_powerup == lasers_powerup:
		if active_lasers == null:
			active_lasers = Lasers.new()
			holder.add_child(active_lasers)
		active_lasers.activate() #Reuses the same timer, restarts it

	held_powerup = null

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var({
		"high_score": high_score,
		"crt_visible": crt_visible,
		"crt_curved": crt_curved,
		"free_move": free_move,
		"vertical_display": vertical_display,
	})
	file.close()

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		high_score = data.get("high_score", 0)
		crt_visible = data.get("crt_visible", false)
		crt_curved = data.get("crt_curved", true)
		free_move = data.get("free_move", false)
		vertical_display = data.get("vertical_display", false)
		file.close()
