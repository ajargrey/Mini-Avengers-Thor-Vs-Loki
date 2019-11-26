extends KinematicBody2D

var iron_rect_health
var move_speed = 500
var jump_speed = 1600
var gravity = 100
var fly_position_change = 20
var fly = false
var jump = false
var facing_right = true
var attack_ready = false
var in_air = true
var planos_being_hit
var velocity = Vector2()
var mana = 500
var shooting = false
onready var bullet_scene = preload("res://Scenes/Players/Iron_rect/Iron_rect_beam.tscn")

func _ready():
	$"AnimationPlayer_snap_effect".play("Default")
	global.script_iron_rect_body = self
	iron_rect_health = 3
	planos_being_hit = global.var_planos_being_hit
	global.var_iron_rect_mana = mana

func _process(delta):
	global.var_iron_rect_facing_right = facing_right
	global.var_iron_rect_health = iron_rect_health
	global.var_iron_rect_body_position = global_position
	planos_being_hit = global.var_planos_being_hit
	global.var_iron_rect_mana = mana

func _physics_process(delta):
	moving()
	jumping()
	attacking()
	move_and_slide(velocity, Vector2(0,-1) )
	toggle_control_states()

func moving():
	velocity.x = 0  
	if Input.is_action_pressed('ui_right') or global.var_right_pressed :
		velocity.x += move_speed
		if not facing_right :
			$"snap_effect".flip_h = false
			scale.x = -1
			facing_right = true
	elif Input.is_action_pressed('ui_left') or global.var_left_pressed :
		velocity.x -= move_speed
		if facing_right :
			$"snap_effect".flip_h = true
			scale.x = -1
			facing_right = false

func jumping():
	if not is_on_floor() :
		in_air = true
	if is_on_floor() :
	 	velocity.y = 0
	 	jump = false
	if fly == false :
		if Input.is_action_just_pressed('ui_up') or global.var_up_just_pressed :
			if is_on_floor():
				velocity.y -= jump_speed 
				jump = true
				$"Sounds/Audio_jump".play()
			if not is_on_floor() and jump == true :
				if Input.is_action_just_pressed('ui_up') or global.var_up_just_pressed :
					fly = true
					$AnimationPlayer_wings.play("Expand_wings")
					position.y -= fly_position_change
		else :
			velocity.y += gravity
	if fly == true :
		velocity.y = 0
		if Input.is_action_pressed('ui_up') or global.var_up_pressed :
			velocity.y -= move_speed
		if Input.is_action_pressed('ui_down') or global.var_down_pressed :
			fly = false
			$AnimationPlayer_wings.play("Shrink_wings")
	if in_air :
		if is_on_floor() :
			$"Sounds/Audio_land".play()
			in_air = false

func attacking() :
	if (Input.is_action_just_pressed('ui_shoot') or global.var_shoot_just_pressed) and global.var_planos_vulnerable and mana > 0:
		get_node("AnimationPlayer_hands").play("Shoot")
		$"Sounds/Audio_charge_shoot".play()
		shooting = true
		global.script_tighten_camera.shake(0.2, 15, 8)
	if (Input.is_action_just_released('ui_shoot') or global.var_shoot_just_released ) or not global.var_planos_vulnerable or mana <= 0 :
			get_node("AnimationPlayer_hands").play("Hold_shoot")
			$"Sounds/Audio_charge_shoot".stop()
			shooting = false
			attack_ready = false
	if (Input.is_action_pressed('ui_shoot') or global.var_shoot_pressed) and attack_ready and global.var_planos_vulnerable and mana > 0:
		shoot()
		shooting = true
	if not shooting and mana <= 500 :
		mana = mana + 2

func attack_ready() :
	attack_ready = true

func shoot() :
	var bullet = bullet_scene.instance()
	get_parent().add_child(bullet)
	bullet.global_position=get_node("Iron_hand_right/Position").get_global_position()
	mana = mana - 1

func player_hit() :
	get_tree().paused = true
	global.script_tighten.play_flash_red()
	iron_rect_health -= 1
	global.script_tighten.player_hit()
	if iron_rect_health <= 0 :
		game_over()

func player_hit_by_pillar() :
	$"AnimationPlayer_snap_effect".play("Hit")
	global.script_tighten.player_hit()
	get_tree().paused = true
	global.script_tighten.play_flash_red()
	iron_rect_health -= 1
	if iron_rect_health <= 0 :
		game_over()

func game_over() :
#	$"Timer_die".start()
	queue_free()
#	pass

func _on_Timer_die_timeout():
	global.script_tighten.game_over()

func toggle_control_states() :
	if global.var_shoot_just_pressed == true :
		global.var_shoot_just_pressed = false
	if global.var_shoot_just_released == true :
		global.var_shoot_just_released = false
	if global.var_up_just_pressed == true :
		global.var_up_just_pressed = false

