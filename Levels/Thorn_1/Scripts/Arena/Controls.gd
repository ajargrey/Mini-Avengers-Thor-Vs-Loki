extends CanvasLayer

var moving_left = false
var moving_right = false
var jumping = false
var shooting = false

onready var tsb_left = $"Arrow_keys/Node2D/TSB_left"
onready var tsb_right = $"Arrow_keys/Node2D/TSB_right"
onready var tsb_up = $"Shoot_key/Node2D/TSB_up"
onready var tsb_shoot = $"Shoot_key/Node2D/TSB_shoot"

func _ready():
	pass

func _process(delta):
	Global_thorn_1.var_moving_left = moving_left
	Global_thorn_1.var_moving_right = moving_right
	Global_thorn_1.var_jumping = jumping
	Global_thorn_1.var_shooting = shooting
	
	if tsb_left.is_pressed() :
		moving_left = true
	else :
		moving_left = false
	
	if tsb_right.is_pressed() :
		moving_right = true
	else :
		moving_right = false
	
	if tsb_up.is_pressed() :
		jumping = true
	else :
		jumping = false
	
	if tsb_shoot.is_pressed() :
		shooting = true
	else :
		shooting = false