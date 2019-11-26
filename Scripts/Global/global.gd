extends Node
#########################################

#Tighten

#variables
var var_left_pressed = false
var var_right_pressed = false
var var_up_pressed = false
var var_up_just_pressed = false
var var_down_pressed = false
var var_shoot_pressed = false
var var_shoot_just_pressed = false
var var_shoot_just_released = false

var var_iron_rect_facing_right
var var_iron_rect_health
var var_iron_rect_mana
var var_iron_rect_body_position = Vector2()
var var_planos_health = 100
var var_planos_vulnerable = false
var var_planos_being_hit = false

#scripts
var script_iron_rect_body
var script_iron_rect_beam
var script_planos_body
var script_tighten_meteor
var script_tighten
var script_tighten_camera
####################################################