extends	Camera2D

@export	var	zoom_speed:	float =	0.1
@export	var	min_zoom: float	= 0.2
@export	var	max_zoom: float	= 3.0

var	dragging := false
var	last_mouse_position	:= Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index	== MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)
	if event is InputEventPanGesture:
		if event.delta.y > 0:
			zoom_camera(zoom_speed)
		elif event.delta.y < 0:
			zoom_camera(-zoom_speed)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
			last_mouse_position	= get_viewport().get_mouse_position()
	
	# Two-finger pan
	if event is InputEventPanGesture:
		position -= event.delta	/ zoom
	elif event is InputEventMagnifyGesture:
		zoom *= event.factor
		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)
	
	elif event is InputEventMouseMotion	and	dragging:
		var	current_pos	= get_viewport().get_mouse_position()
		var	delta =	current_pos	- last_mouse_position
		position -= delta /	zoom  # 考慮 zoom	  比例
		last_mouse_position	= current_pos

func zoom_camera(amount: float):
	var	old_zoom = zoom
	var	new_zoom = zoom	+ Vector2(amount, amount)

	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)

	# 調整位置讓滑鼠位置維持原樣
	var	mouse_pos =	get_global_mouse_position()
	var	_offset	= (mouse_pos - global_position)	* (new_zoom	/ old_zoom - Vector2(1,	1))
	global_position	+= _offset

	zoom = new_zoom
