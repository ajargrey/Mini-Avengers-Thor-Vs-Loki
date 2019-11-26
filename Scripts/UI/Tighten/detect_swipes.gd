extends Node2D

var ini_pos

func _ready():
	pass

func _process(delta):
	pass

func _input(event) :
	if event is InputEventScreenTouch :
		ini_pos = event.get_position()
		print(event.position)
		print ("")
		if event.position.x - ini_pos.x > 5 :
			global.var_right_pressed = true