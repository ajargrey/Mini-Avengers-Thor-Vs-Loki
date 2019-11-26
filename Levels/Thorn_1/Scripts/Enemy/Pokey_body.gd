extends KinematicBody2D

var spawned = false
var player_position = Vector2()
var position_left_x = 98
var position_right_x = 1108
var velocity = Vector2()
var move_speed = 100
var gravity = 100
var playing_scepter_blasting = false
var playing_knife_throwing = false
var playing_point_scepter = false
var checkpoint = 0
var health = 50
var facing_left = true
onready var projectile_scene = preload("res://Levels/Thorn_1/Scenes/Enemies/Scepter_projectile.tscn")
onready var knife_scene = preload("res://Levels/Thorn_1/Scenes/Enemies/Ice_knife.tscn")

func _ready():
	Global_thorn_1.script_pokey_body = self
	$"AP_attacks".play("Idle")

func _process(delta):
	_update_local_variables()
	_update_global_variables()
	manage_checkpoints()
	wander(delta)
	keep_timer_game_over_running()

func _physics_process(delta):
	fall()

func Scepter_blast() :
	Global_thorn_1.script_camera.shake(0.1, 15, 10)
	$"Audio_scepter_blast".play()
	var projectile = projectile_scene.instance()
	get_parent().add_child(projectile)
	projectile.global_position = $"Pokey_scepter/Scepter_point".get_global_position()

func Throw_knife(hand) :
	Global_thorn_1.script_camera.shake(0.1, 15, 10)
	$"Audio_throw_knife".play()
	var knife = knife_scene.instance()
	get_parent().add_child(knife)
	if hand == "right" :
		knife.global_position = $"Pokey_hand_right".get_global_position()
	elif hand == "left" :
		knife.global_position = $"Pokey_hand_left".get_global_position()

func _update_local_variables() :
	checkpoint = Global_thorn_1.var_checkpoint
	player_position = Global_thorn_1.var_player_position

func _update_global_variables() :
	Global_thorn_1.var_pokey_facing_left = facing_left
	if not checkpoint == 3 :
		Global_thorn_1.var_pokey_health = health
	if checkpoint == 3 :
		health = 1


func manage_checkpoints() :
	if checkpoint == 1 and not playing_scepter_blasting :
		$"AP_attacks".play("Scepter_blasting")
		playing_scepter_blasting = true
	if checkpoint == 2 and not playing_knife_throwing :
		$"AP_attacks".play("Knife_throwing")
		$"AP_attacks".playback_speed = 1
		playing_knife_throwing = true
		playing_scepter_blasting = false
	if checkpoint == 3 and not playing_point_scepter :
		$"AP_attacks".play("Point_scepter")
		playing_point_scepter = true
		playing_knife_throwing = false

func pokey_hurt() :
	$"Audio_hit".play()
	health -= 1
	if not checkpoint == 2 and not checkpoint == 3 :
		$"AP_vfx".play("Pow_effect")
	if checkpoint == 2 :
		$"AP_vfx".play("Poof_effect")
		if facing_left :
			if rand_range(0,2) >= 0.5 :
				scale.x *= -1
				$"VFX".flip_h = true
				global_position.x = position_left_x
				facing_left = false
		elif not facing_left :
			if rand_range(0,2) >= 0.5 :
				scale.x *= -1
				$"VFX".flip_h = false
				global_position.x = position_right_x
				facing_left = true
	if checkpoint == 3 :
		Global_thorn_1.var_pokey_health -= 0.3
	if health == 0 :
		destroy()

func After_spawning() :
	spawned = true

func fall() :
	if spawned :
		velocity.y += gravity
	elif not spawned :
		velocity.y = 0
	if is_on_floor() :
		velocity.y = 0

func wander(delta) :
	if not checkpoint == 3 :
		velocity.x = 0
	move_and_slide( velocity, Vector2(0, -1) )
	if checkpoint == 3 :
		if global_position.x - player_position.x > 0 :
			if is_on_floor() :
				velocity.x = -1*move_speed
			if not facing_left :
				scale.x *= -1
				facing_left = true
				$"VFX".flip_h = false
		if global_position.x - player_position.x < 0 :
			if is_on_floor() :
				velocity.x = move_speed
			if facing_left :
				scale.x *= -1
				facing_left = false
				$"VFX".flip_h = true

func destroy() :
#	$"..".queue_free()
#	$"Pokey_scepter/CollisionShape2D".queue_free()
	$"Area2D".queue_free()
#	$"AP_vfx".play("Powf_effect")
	$"Sprite".queue_free()
	$"CollisionShape2D".queue_free()
	$"Pokey_hand_left".queue_free()
	$"Pokey_hand_right".queue_free()
	$"Pokey_scepter".queue_free()
	$"Timer_final_moments".start()

#func dead() :
#	queue_free()

func _on_Area2D_area_entered(area):
	pokey_hurt()

func keep_timer_game_over_running() :
	Global_thorn_1.script_arena.timer_game_over_start()

func _on_Pokey_scepter_area_entered(area):
	if checkpoint == 3 :
		Global_thorn_1.script_thorn_body.player_hurt()
		pokey_hurt()

func _on_Timer_final_moments_timeout():
	$"..".queue_free()
