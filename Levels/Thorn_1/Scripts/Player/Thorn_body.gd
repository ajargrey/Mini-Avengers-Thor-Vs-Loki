extends KinematicBody2D

var moving_left
var moving_right
var shooting
var jumping
var velocity = Vector2(0, 0)
var moving_speed = 300
var gravity = 100
var jump_speed = 1600
var is_facing_right = true
var hammer_is_called_back = false
var hammer_is_in_hand = true
var invincible = false
var health = 3

func _ready():
	Global_thorn_1.script_thorn_body = self

func _process(delta):
	_update_global_variables()
	_update_local_variables()
	attacking(delta)
	moving()
	move_and_slide(velocity, Vector2(0, -1) )

func _physics_process(delta):
	jumping_and_falling()

func _update_global_variables() :
	Global_thorn_1.var_is_facing_right = is_facing_right
	Global_thorn_1.var_hammer_is_called_back = hammer_is_called_back
	Global_thorn_1.var_player_position = global_position
	Global_thorn_1.var_player_health = health

func _update_local_variables() :
	moving_left = Global_thorn_1.var_moving_left
	moving_right = Global_thorn_1.var_moving_right
	jumping = Global_thorn_1.var_jumping
	shooting = Global_thorn_1.var_shooting
	hammer_is_in_hand = Global_thorn_1.var_hammer_is_in_hand

func moving() :
	velocity.x = 0
	if moving_left :
		velocity.x -= moving_speed
		if is_facing_right :
			if not hammer_is_in_hand :
				hammer_is_called_back = true
			scale.x *= -1
			$"SFX/Sprite".flip_h = true
			is_facing_right = false
	elif moving_right :
		velocity.x += moving_speed
		if not is_facing_right :
			if not hammer_is_in_hand :
				hammer_is_called_back = true
			scale.x *= -1
			$"SFX/Sprite".flip_h = false
			is_facing_right = true

func jumping_and_falling() :
	velocity.y += gravity
	if is_on_floor() :
		velocity.y = 0
	if is_on_floor() and jumping :
		velocity.y -= jump_speed
		$"Audio_jump".play()

func attacking(delta):
	if shooting and not hammer_is_called_back :
		Global_thorn_1.script_thorn_hammer.thrown(delta)
	if not shooting :
		if not hammer_is_called_back and not hammer_is_in_hand :
			hammer_is_called_back = true

func hammer_came_back() :
	if hammer_is_in_hand :
		hammer_is_called_back = false

func call_back_hammer() :
	hammer_is_called_back = true

func player_hurt() :
	if not invincible :
		invincible = true
		$"../Timer_invincible".start()
		$"Audio_hit".play()
		health -= 1
		Global_thorn_1.var_player_health = health
		$"SFX/AnimationPlayer".play("Bam_effect")
		Global_thorn_1.script_arena.player_hurt()
		if health <= 0 :
			game_over()
		print(health)

#func _on_Area2D_area_entered(area):
#	var projectile_node = area.get_parent()
#	projectile_node.queue_free()
#	player_hurt()

func game_over() :
	$".".queue_free()

func _on_Timer_invincible_timeout():
	invincible = false
