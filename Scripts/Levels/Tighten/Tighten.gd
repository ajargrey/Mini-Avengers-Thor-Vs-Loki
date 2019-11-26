extends Node2D

var planos
var temp = 0
var pillar_gap = 500
var current_player_pos 
var iron_rect_mana 
var iron_rect_health = 3
var planos_health = 100
var mana_scale_x_ini
var boss_health_scale_x_ini
var phase_one_started = false
var phase_two_started = false
var phase_three_started = false
onready var meteor_scene = preload("res://Scenes/Levels/Tighten/Tighten_meteor.tscn")
onready var tighten_level = preload("res://Scenes/Levels/Tighten/Tighten.tscn")

func _ready():
	global.script_tighten = self
	current_player_pos = $Iron_rect.global_position
	mana_scale_x_ini = $"Info_bars/Player_mana/Mana_active".scale.x
	boss_health_scale_x_ini = $"Info_bars/Planos_health/Health_active".scale.x

func _process(delta):
	current_player_pos = global.var_iron_rect_body_position
	manage_player_bars()
	manage_planos_bar()
	if Input.is_action_pressed("ui_page_up") :
		get_tree().change_scene_to(tighten_level)
	if phase_three_started :
		$"Side_pillar_1".global_position.y = $"Side_pillars".global_position.y
		$"Side_pillar_2".global_position.y = $"Side_pillars".global_position.y
		$"Side_pillar_3".global_position.y = $"Side_pillars".global_position.y
		$"Side_pillar_4".global_position.y = $"Side_pillars".global_position.y
		$"Side_pillar_5".global_position.y = $"Side_pillars".global_position.y

func start_meteor_shower():
	$Timer_meteor_spawn.start()

func _on_Timer_meteor_spawn_timeout():
	var meteor = meteor_scene.instance()
	get_parent().add_child(meteor)
	meteor.global_position.x = rand_range(410, 2480)
	meteor.global_position.y = rand_range(-520, -750)
	$Timer_meteor_spawn.start()

func phase_one() :
	if not phase_one_started :
		phase_one_started = true
		$"Sounds/Audio_bg_p_1".play()
		global.script_tighten_camera.shake(2, 15, 8)
		global.script_planos_body.play_shoot_projectile()

func phase_two() :
	if not phase_two_started :
		$"Sounds/Audio_bg_p_1".stop()
		$"Sounds/Audio_bg_p_2".play()
		global.script_tighten_camera.shake(8, 15, 8)
		phase_two_started = true
		global.script_planos_body.play_use_gauntlet()

func play_rising_main_pillar() :
	$"AnimationPlayer_main_pillar".play("Rising_main_pillar")

func rising_main_pillar_finished() :
	global.script_planos_body.play_blast_moon()

func phase_two_continued() :
	start_meteor_shower()

func phase_three():
	if not phase_three_started :
		phase_three_started = true
		$"Sounds/Audio_bg_p_2".stop()
		$"Sounds/Audio_bg_p_3".play()
		$"Timer_meteor_spawn".queue_free()
		global.script_planos_body.switch_off_vulnerable()
		$"AnimationPlayer_main_pillar".play("Falling_main_pillar")

func falling_main_pillar_finished() :
	global.script_planos_body.switch_on_vulnerable()
	global.script_planos_body.play_summon_side_pillars()

func side_pillars_uprising() :
	$"Side_pillar_1".global_position.x = current_player_pos.x 
	$"Side_pillar_2".global_position.x = current_player_pos.x  + rand_range(100, pillar_gap)
	$"Side_pillar_3".global_position.x = current_player_pos.x  - rand_range(100, pillar_gap)
	$"Side_pillar_4".global_position.x = current_player_pos.x  + rand_range(pillar_gap + 100, pillar_gap*2)
	$"Side_pillar_5".global_position.x = current_player_pos.x  - rand_range(pillar_gap + 100, pillar_gap*2)
	$"Side_pillars/AnimationPlayer_side_pillars".play("Side_pillars_uprising")

func side_pillars_uprising_finished() :
	global.script_planos_body.play_summon_side_pillars()

func _on_Side_pillar_body_entered(body):
	 # replace with function body, idk what it means, so i leave it like this
	global.script_iron_rect_body.player_hit_by_pillar()

func manage_player_bars():
	iron_rect_mana = global.var_iron_rect_mana
	$"Info_bars/Player_mana/Mana_active".scale.x = mana_scale_x_ini*( (float(iron_rect_mana))/500 )

func manage_planos_bar():
	planos_health = global.var_planos_health
	$"Info_bars/Planos_health/Health_active".scale.x = boss_health_scale_x_ini*( planos_health/100 )
	var life_3_lost = false
	var life_2_lost = false
	var life_1_lost = false
	if iron_rect_health==3 and not life_3_lost:
		$"Info_bars/Player_lives/AnimationPlayer".play("Life_3_lost")
		life_3_lost = true
	if iron_rect_health==2 and not life_2_lost:
		$"Info_bars/Player_lives/AnimationPlayer".play("Life_2_lost")
		life_2_lost = true
	if iron_rect_health==1 and not life_1_lost:
		$"Info_bars/Player_lives/AnimationPlayer".play("Life_1_lost")
		life_1_lost = true

func player_hit():
	iron_rect_health -= 1
	print(iron_rect_health)


func play_flash_red() :
	$"Background/AnimationPlayer".play("Flash_background")

func start_again() :
	get_tree().paused = false

func game_over() :
	pass