extends Node2D

var projectile_speed = 800
var bullet_hit = false
var moving = false
var collided = false

func _ready():
	$"Area2D/AnimationPlayer".play("Default")
#	z_index = -1

func _process(delta):
	if not bullet_hit and moving:
		global_position.x -= projectile_speed*delta
		if not $"VisibilityNotifier2D".is_on_screen() :
			queue_free()

func _on_Area2D_body_entered(body):
	pause_mode = PAUSE_MODE_PROCESS
	play_destroy_effect()
	bullet_hit = true
	global.script_iron_rect_body.player_hit()

func play_destroy_effect() :
	z_index = 3
	$"Area2D/AnimationPlayer".play("Hit")
	$"Audio_hit".play()

func destroy_projectile() :
	queue_free()

func start_moving() :
	moving = true
	z_index = -1