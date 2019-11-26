extends Node2D

var direction = 1
var speed = 1000

func _ready():
	get_direction()
	play_rotating_animation()

func _process(delta):
	travel(delta)

func get_direction() :
	if Global_thorn_1.var_pokey_facing_left :
		direction = 1
	elif not Global_thorn_1.var_pokey_facing_left :
		direction = -1

func play_rotating_animation() :
	if direction == 1 :
		$"Area2D/AP".play("Rotating_anticlockwise")
	elif direction == -1 :
		$"Area2D/AP".play("Rotating_clockwise")

func travel(delta) :
	position.x -= direction*speed*delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area):
	Global_thorn_1.script_thorn_body.player_hurt()
	$".".queue_free()
