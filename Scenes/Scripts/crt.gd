extends CanvasLayer
@onready var crt_rect := $crt1
@onready var crt_material: ShaderMaterial = crt_rect.material
var curved := true
const CURVE_ON := 8.5
const CURVE_OFF := 100.0

const HORIZONTAL = preload("res://shaders/crt1_horizontal.gdshader")
const VERTICAL = preload("res://shaders/crt1_vertical.gdshader")

func _ready():
	# load saved settings
	curved = GameState.crt_curved
	visible = GameState.crt_visible
	_apply()
	
	if GameState.vertical_display:
		crt_material.shader = VERTICAL
	else:
		crt_material.shader = HORIZONTAL

func _input(event):
	if event.is_action_pressed("shift_f12"):
		curved = !curved
		GameState.crt_curved = curved      # update
		GameState.save_data()              # persist
		_apply()
	elif event.is_action_pressed("alt_f12"):
		GameState.vertical_display = !GameState.vertical_display
		if GameState.vertical_display:
			crt_material.shader = VERTICAL
		else:
			crt_material.shader = HORIZONTAL
	elif event.is_action_pressed("f12"):
		visible = !visible
		GameState.crt_visible = visible
		GameState.save_data()

func _apply():
	crt_material.set_shader_parameter("curvature", CURVE_ON if curved else CURVE_OFF)
