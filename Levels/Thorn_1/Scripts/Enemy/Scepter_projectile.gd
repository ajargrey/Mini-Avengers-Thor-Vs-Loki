extends Node2D

var speed = 1000

func _ready():
	pass

func _process(delta):
	travel(delta)

func travel(delta) :
	position.x -= speed*delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_area_entered(area):
	Global_thorn_1.script_thorn_body.player_hurt()
	$".".queue_free()
