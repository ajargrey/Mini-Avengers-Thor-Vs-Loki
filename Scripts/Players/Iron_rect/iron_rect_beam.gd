extends Node2D

var damage = 0.03 #Use 0.03 if not debuggung
var facing_right
var direction
var bullet_speed = 1600

func _ready():
	global.script_iron_rect_beam = self
	facing_right = global.var_iron_rect_facing_right
	if facing_right :
		direction = 1
	if not facing_right :
		direction = -1

func _process(delta):
	global_position.x += bullet_speed*direction*delta
	if not $"VisibilityNotifier2D".is_on_screen() :
		queue_free()


func _on_Area2D_body_entered(body):
	global.script_planos_body.planos_hit(damage)
	destroy_bullet()# replace with function body ; I have no idea what it means

func destroy_bullet():
	queue_free()