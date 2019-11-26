extends Node2D

var moving_speed = 500
var falling_speed = 500
var rotating_speed
var rand_scale
var once_visible = false
var meteor_hit = false
var collided = false

func _ready():
	$"Area2D/AnimationPlayer".play("Default")
	z_index = -3
	global.script_tighten_meteor = self
	moving_speed *= rand_range(0.5, 1)
	falling_speed *= rand_range(0.5, 1)
	rotating_speed = rand_range(0, 7)
	rand_scale = rand_range(0.5, 1.5)
	scale.x *= rand_scale
	scale.y *= rand_scale

func _process(delta):
	if not meteor_hit :
		position.x -= moving_speed*delta
		position.y += falling_speed*delta
		rotation += rotating_speed*delta
		destroy_off_screen()
		if position.y >= 505 :
			if not collided :
				play_destroy_effect()
				moving_speed = 0
				falling_speed = 0
				rotating_speed = 0
			collided = true

func _on_Area2D_body_entered(body):
	if not collided :
		pause_mode = PAUSE_MODE_PROCESS
		play_destroy_effect()
		meteor_hit = true
		global.script_iron_rect_body.player_hit()
		# replace with function body, I have no idea what it means

func destroy_off_screen() :
	if $"VisibilityNotifier2D".is_on_screen() :
		once_visible = true
	if once_visible and not $"VisibilityNotifier2D".is_on_screen() :
		queue_free()

func play_destroy_effect() :
	z_index = 3
	$"Area2D/AnimationPlayer".play("Hit")
	$"Audio_hit".play()

func destroy_meteor():
	queue_free()