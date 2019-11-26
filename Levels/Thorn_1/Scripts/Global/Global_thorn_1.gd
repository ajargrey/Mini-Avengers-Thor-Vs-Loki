extends Node

#Variables
var var_moving_right = false
var var_moving_left = false
var var_jumping = false
var var_shooting = false

var var_player_health = 3
var var_player_position = Vector2()
var var_is_facing_right = true
var var_hammer_is_in_hand = true
var var_hammer_is_called_back = false
var var_pokey_facing_left = true
var var_pokey_health = 50
var var_checkpoint = 0

#Scripts
var script_arena
var script_camera
var script_thorn_body
var script_thorn_hammer
var script_pokey_body