extends KinematicBody2D

var vulnerable = true
var being_hit = false
var is_playing_hit_flash = false
var planos_health = 100
var falling_speed = 500
var velocity = Vector2()
var planos_destroyed = false
onready var projectile_scene = preload("res://Scenes/Bosses/Planos/Planos_projectile.tscn")

func _ready():
	global.script_planos_body = self
	$"AnimationPlayer".play("Default")

func _process(delta):
	global.var_planos_health = planos_health
	global.var_planos_vulnerable = vulnerable
	global.var_planos_being_hit = being_hit

func _physics_process(delta):
	falling()
	move_and_slide( velocity, Vector2(0, -1) )

func falling() :
	velocity.y = 0
	if not is_on_floor() :
		velocity.y += falling_speed
	if is_on_floor():
		velocity.y = 0

func planos_hit(damage) :
	if vulnerable and not planos_destroyed:
		planos_health -= damage
		being_hit = true
		$"Timer_being_hit".start()
		if not is_playing_hit_flash :
			$"AnimationPlayer_hit_flash".play("Hit_flash")
			is_playing_hit_flash = true
		if planos_health < 95 and planos_health > 90 :
			global.script_tighten.phase_one()
		if planos_health < 70 and planos_health > 60 :
			global.script_tighten.phase_two()
		if planos_health <30 and planos_health > 20 :
			global.script_tighten.phase_three()
		if planos_health <= 0 and not planos_destroyed :
			vulnerable = false
			destroy_planos()

func play_use_gauntlet() :
	$"AnimationPlayer".play("Use_gauntlet")
	vulnerable = false

func use_gauntlet_finished() :
	global.script_tighten.play_rising_main_pillar()

func play_blast_moon() :
	$"AnimationPlayer".play("Blast_moon")
	is_playing_hit_flash = false

func blast_moon_finished() :
	vulnerable = true

func blast_moon_middle() :
	global.script_tighten.phase_two_continued()

func hit_flash_finished() :
	is_playing_hit_flash = false

func play_shoot_projectile() :
	$"AnimationPlayer".play("Shoot_projectile")

func shoot_projectile() :
	$"Sounds/Audio_shoot_bullet".play()
	global.script_tighten_camera.shake(0.1, 15, 10)
	var projectile = projectile_scene.instance()
	get_parent().add_child(projectile)
	projectile.global_position = get_node("Planos_gauntlet").get_global_position()

func destroy_planos() :
	if not planos_destroyed :
		planos_destroyed = true
		global.script_tighten_camera.shake(6, 15, 8)
		$"AnimationPlayer".play("Teleport")
		$"Sounds/Audio_portal".play()


func switch_off_vulnerable() :
	vulnerable = false

func switch_on_vulnerable() :
	vulnerable = true

func play_summon_side_pillars() :
	if not planos_destroyed :
		$"AnimationPlayer".play("Summon_side_pillars")
		global.script_tighten_camera.shake(0.1, 15, 8)

func summon_side_pillars_middle() :
	global.script_tighten.side_pillars_uprising()

func _on_Timer_being_hit_timeout():
	being_hit = false
