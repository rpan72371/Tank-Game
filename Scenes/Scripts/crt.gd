extends CanvasLayer
@onready var crt_rect := $crt1
@onready var crt_material: ShaderMaterial = crt_rect.material
var curved := true
const CURVE_ON := 8.5
const CURVE_OFF := 100.0

func _ready():
	# load saved settings
	curved = GameState.crt_curved
	visible = GameState.crt_visible
	_apply()

func _input(event):
	if event.is_action_pressed("shift_f12"):
		curved = !curved
		GameState.crt_curved = curved      # update
		GameState.save_data()              # persist
		_apply()
	elif event.is_action_pressed("f12"):
		visible = !visible
		GameState.crt_visible = visible
		GameState.save_data()

func _apply():
	crt_material.set_shader_parameter("curvature", CURVE_ON if curved else CURVE_OFF)
