extends Node2D

var point_1_checked = false
var point_2_checked = false
var point_3_checked = false
var ini_boss_health_scale_x
var pokey_defeated = false
var checkpoint
var player_health
var pokey_health
var player_position
var timer_started = false
var played_health_2 = false
var played_health_1 = false
var played_health_0 = false
onready var pokey_scene = preload("res://Levels/Thorn_1/Scenes/Enemies/Pokey.tscn")

func _ready():
	Global_thorn_1.script_arena = self
	ini_boss_health_scale_x = $"Info_bars/Boss_health/Node2D/Health_active".scale.x

func _process(delta):
	_update_global_variables()
	_update_local_variables()
	manage_checkpoints()
	manage_boss_health_bar()

func _update_local_variables() :
	player_health = Global_thorn_1.var_player_health
	pokey_health = Global_thorn_1.var_pokey_health
	player_position = Global_thorn_1.var_player_position

func _update_global_variables() :
	Global_thorn_1.var_checkpoint = checkpoint

func manage_checkpoints() :
	if pokey_health == 49 and not point_1_checked :
		point_1_checked = true
		checkpoint = 1
		$"Audio_bg_1".play()
	if pokey_health == 39 and not point_2_checked :
		point_2_checked = true
		checkpoint = 2
		$"Audio_bg_2".play()
		$"Audio_bg_1".stop()
	if pokey_health == 25 :
		start_spawn_system()
		if not point_3_checked :
			point_3_checked = true
			checkpoint = 3
			$"Audio_bg_3".play()
			$"Audio_bg_2".stop()

func start_spawn_system() :
	if not timer_started :
		timer_started = true
		$"Timer_pokey_spawner".start()

func _on_Timer_pokey_spawner_timeout():
	if pokey_health > 1 :
		spawn_pokey()
		$"Timer_pokey_spawner".start()

func spawn_pokey() :
	var new_pokey_pos = Vector2()
	if rand_range(0, 1) >= 0.5 :
		new_pokey_pos.x = player_position.x + rand_range(200, 1000)
	else :
		new_pokey_pos.x = player_position.x  - rand_range(200, 1000)
	new_pokey_pos.y = player_position.y - rand_range(100, 500)
	var new_pokey = pokey_scene.instance()
	get_parent().add_child(new_pokey)
	new_pokey.global_position =  new_pokey_pos

func manage_boss_health_bar() :
	if pokey_health > 0 and not pokey_defeated:
		$"Info_bars/Boss_health/Node2D/Health_active".scale.x = float(ini_boss_health_scale_x*(float(pokey_health)/50))
	if  pokey_defeated :
		$"Info_bars/Boss_health/Node2D/Health_active".scale.x = 0

func timer_game_over_start() :
	$"Timer_game_over".start()
	pokey_defeated = false

func _on_Timer_game_over_timeout():
	pokey_defeated = true
	print("You win")

func player_hurt() :
	player_health = Global_thorn_1.var_player_health
	print(player_health)
	if player_health == 2 :
		if not played_health_2 :
			$"Info_bars/Player_health/Node2D/AP_health".play("Health_2")
			played_health_2  = true
	elif player_health == 1 :
		if not played_health_1 :
			$"Info_bars/Player_health/Node2D/AP_health".play("Health_1")
			played_health_1 = true
	elif player_health == 0 :
		if not played_health_0 :
			played_health_0 = true
			$"Info_bars/Player_health/Node2D/AP_health".play("Health_0")
	$"Background/AP_background".play("Flash_red")
	get_tree().paused = true

func resume_game() :
	get_tree().paused = false