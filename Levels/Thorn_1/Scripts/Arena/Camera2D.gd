extends Camera2D

var y
var x
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _duration = 0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)

func _ready():
	Global_thorn_1.script_camera = self
	set_process(true)
	replace_buttons()

# Shake with decreasing intensity while there's time remaining.
func _process(delta):
    resize_screen()
    resize_elements()
    # Only shake when there's shake time remaining.
    if _timer == 0:
        return
    # Only shake on certain frames.
    _last_shook_timer = _last_shook_timer + delta
    # Be mathematically correct in the face of lag; usually only happens once.
    while _last_shook_timer >= _period_in_ms:
        _last_shook_timer = _last_shook_timer - _period_in_ms
        # Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
        var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
        # Noise calculation logic from http://jonny.morrill.me/blog/view/14
        var new_x = rand_range(-1.0, 1.0)
        var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
        var new_y = rand_range(-1.0, 1.0)
        var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
        _previous_x = new_x
        _previous_y = new_y
        # Track how much we've moved the offset, as opposed to other effects.
        var new_offset = Vector2(x_component, y_component)
        set_offset(get_offset() - _last_offset + new_offset)
        _last_offset = new_offset
    # Reset the offset when we're done shaking.
    _timer = _timer - delta
    if _timer <= 0:
        _timer = 0
        set_offset(get_offset() - _last_offset)

# Kick off a new screenshake effect.
func shake(duration, frequency, amplitude):
    # Initialize variables.
    _duration = duration
    _timer = duration
    _period_in_ms = 1.0 / frequency
    _amplitude = amplitude
    _previous_x = rand_range(-1.0, 1.0)
    _previous_y = rand_range(-1.0, 1.0)
    # Reset previous offset, if any.
    set_offset(get_offset() - _last_offset)
    _last_offset = Vector2(0, 0)

func resize_screen() :
	var x1 = $"../Coordinates/Control/x1".global_position.x
	var x2 = $"../Coordinates/Control2/x2".global_position.x
	var y1 = $"../Coordinates/Control3/y1".global_position.y
	var y2 = $"../Coordinates/Control4/y2".global_position.y
	y = y2 - y1
	x = x2 - x1
	var X = 1200.01
	var Y = 600.01
	if Y/y >= X/x :
		zoom.y = Y/y
		zoom.x = Y/y
	if X/x > Y/y :
		zoom.y = X/x
		zoom.x = X/x

func resize_elements() :
	#resize_buttons
	var b_scale = (x*1.1)/(1.5*80*13)
	$"../Controls/Arrow_keys/Node2D".scale.x = b_scale
	$"../Controls/Arrow_keys/Node2D".scale.y = b_scale
	$"../Controls/Shoot_key/Node2D".scale.x = b_scale
	$"../Controls/Shoot_key/Node2D".scale.y = b_scale
	#resize_health_bars
	var h_scale = (x*2.5)/(0.22*784*13)
	$"../Info_bars/Boss_health/Node2D".scale.x = h_scale
	$"../Info_bars/Boss_health/Node2D".scale.y = h_scale
	$"../Info_bars/Player_health/Node2D".scale.x = h_scale
	$"../Info_bars/Player_health/Node2D".scale.y = h_scale

func replace_buttons() :
	pass