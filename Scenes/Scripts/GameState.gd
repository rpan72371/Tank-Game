extends Node
const initial_velocity = 300
const SAVE_PATH = "user://savedata.save"

const shields_powerup = "res://Scenes/Scripts/shields.gd"
const lasers_powerup = "res://Scenes/Scripts/lasers.gd"
var held_powerup = null

var grv = 0
var first_game = true
var is_alive = false
var reset = false
var global_iframes = 0.75
var hp = 3
var score = 0
var high_score = 0
var can_score = false
var iframe = false

var shield_active = false
var lasers_active = false

var shield_pickup = false
var lasers_pickup = false

func _ready():
	load_data()

func _process(delta):
	if hp <= 0:
		is_alive = false
	if is_alive:
		grv = initial_velocity
	else:
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
	if !shield_active:
		iframe = true
		hp -= 1
		get_tree().create_timer(global_iframes).timeout.connect(func(): iframe = false)
	
func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var({ "high_score": high_score })
	file.close()

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		high_score = data.get("high_score", 0)
		file.close()

func use_powerup(holder: Node) -> void:
	if held_powerup == null:
		return

	var powerup_script = load(held_powerup)
	var powerup_instance = powerup_script.new()
	holder.add_child(powerup_instance)
	powerup_instance.activate()

	held_powerup = null
