extends CanvasLayer

onready var tsb_left = $"Controls/Node2D/TSB_left"
onready var tsb_right = $"Controls/Node2D/TSB_right"
onready var tsb_up = $"Controls/Node2D/TSB_up"
onready var tsb_down = $"Controls/Node2D/TSB_down"
onready var tsb_shoot = $"X_keys/TSB_shoot"

func _ready():
	tsb_up.connect("pressed", self, "_on_up_just_pressed")
	tsb_shoot.connect("released", self, "_on_shoot_just_released")
	tsb_shoot.connect("pressed", self, "_on_shoot_just_pressed")

func _process(delta):
	if tsb_left.is_pressed() :
		global.var_left_pressed = true
	else :
		global.var_left_pressed = false
	if tsb_right.is_pressed() :
		global.var_right_pressed = true
	else :
		global.var_right_pressed = false
	if tsb_down.is_pressed() :
		global.var_down_pressed = true
	else :
		global.var_down_pressed = false
	if tsb_up.is_pressed() :
		global.var_up_pressed = true
	else :
		global.var_up_pressed = false
	
	if tsb_shoot.is_pressed() :
		global.var_shoot_pressed = true
	else :
		global.var_shoot_pressed = false

func _on_shoot_just_pressed() :
	global.var_shoot_just_pressed = true

func _on_shoot_just_released() :
	global.var_shoot_just_released = true

func _on_up_just_pressed() :
	global.var_up_just_pressed = true

