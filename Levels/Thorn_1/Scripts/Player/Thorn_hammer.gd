extends Node2D

var is_in_hand = true
var is_called_back = false
var playing_in_hand = true
var playing_thrown = false
var speed = 1500
var return_speed = 2000
var player_is_facing_right = true

func _ready():
	Global_thorn_1.script_thorn_hammer = self

func _process(delta):
	_update_global_variables()
	_update_local_variables()
	check_in_hand()
	answer_calls(delta)
	check_if_outside_screen()

func in_hand() :
	if is_in_hand :
		if not playing_in_hand :
			$"Area2D/AnimationPlayer".play("In_hand")
			$"Area2D/Audio_traverse".stop()
			playing_in_hand = true
			playing_thrown = false
			Global_thorn_1.script_camera.shake(0.2, 15, 8)
		Global_thorn_1.script_thorn_body.hammer_came_back()

func thrown(delta) :
	if not is_called_back :
		if not playing_thrown :
			$"Area2D/AnimationPlayer".play("Thrown")
			Global_thorn_1.script_camera.shake(0.2, 15, 8)
			$"Area2D/Audio_traverse".play()
			playing_in_hand = false
			playing_thrown = true
		if player_is_facing_right :
			global_position.x += speed*delta
		elif not player_is_facing_right :
			global_position.x -= speed*delta

func check_in_hand() :
	if is_called_back and abs(position.x) < 50 :
		position.x = 0
	if position.x == 0 :
		is_in_hand = true
		in_hand()
	else :
		is_in_hand = false

func answer_calls(delta) :
	if not is_in_hand and is_called_back :
		if position.x > 0 :
			position.x -= return_speed*delta
		elif position.x < 0 :
			position.x += return_speed*delta

func _update_global_variables() :
	Global_thorn_1.var_hammer_is_in_hand = is_in_hand

func _update_local_variables() :
	player_is_facing_right = Global_thorn_1.var_is_facing_right
	is_called_back = Global_thorn_1.var_hammer_is_called_back

func check_if_outside_screen() :
	if not $"Area2D/VisibilityNotifier2D".is_on_screen() :
		Global_thorn_1.script_thorn_body.call_back_hammer()



func _on_Area2D_body_entered(body):
	Global_thorn_1.script_thorn_body.call_back_hammer()
