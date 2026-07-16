#file defines game state, dead/alive, scoring system, speed, start/end, and save/load functions
extends Node
const initial_velocity = 300 #this changes the speed of the game, could make it a variable to implement different difficulties
const SAVE_PATH = "user://savedata.save"

var grv = 0 # velocity
var first_game = true #what does this do?
var is_alive = false
var reset = false
var global_iframes = 0.5
var hp = 3
var score = 0
var high_score = 0
var can_score = false

var status = true

#this starts the game
func _ready():
	load_data()

#checks hp, if its 0 then end game, otherwise let it continue
func _process(delta):
	if hp <= 0:
		is_alive = false
	if is_alive:
		grv = initial_velocity
	else:
		grv = 0
	
	if can_score and is_alive:
		_add_score()

#periodic point gains
func _add_score():
	can_score = false
	score += 100 #change this
	get_tree().create_timer(2).timeout.connect(_on_score_timeout)

#check whether play can score points
func _on_score_timeout():
	can_score = true

# call this when the player dies (before resetting score),,, logs highscore
func end_run():
	if score > high_score:
		high_score = score
		save_data()

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
