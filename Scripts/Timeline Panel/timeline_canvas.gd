class_name TimelineCanvas extends Control

@export var font: Font 
@export	var	canvas:	Control	
@export	var	duration: float	= 10
@export	var	frame_rate:	int	= 30
@export	var	frame_per_px: float	= 20
@export	var	interval_frame:	int = 4
@export	var	keyframes: Array[Vector2]
@export var time_point: TimePoint
@export var animation_rect_prefab: PackedScene

signal frame_changed(new_time: float)

var total_width: float
var	current_time: float	= 0.0

func _ready():
	total_width = frame_rate * (duration + 1) * frame_per_px
	custom_minimum_size.x = total_width

	for i in keyframes:
		_add_animation_rect(i)

func _draw() -> void:
	print("draw")
	# var	w =	canvas.size.x
	var	h =	canvas.size.y

	for f in range(0, int(frame_rate * duration) + 1, interval_frame):
		var x = f * frame_per_px
		var text = str(f)
		var text_w = font.get_string_size(text).x
		draw_string(font, Vector2(x - (text_w / 2), 20), text)
		draw_line(Vector2(x, 20), Vector2(x, h), Color(0.2, 0.2, 0.2), 1)

	# var	steps =	int(duration * frame_rate /	interval_frame)
	# for	i in range(steps + 1):
	# 	var	x =	float(i) * frame_per_px	* interval_frame
	# 	var frame = int(i * interval_frame)
	# 	draw_string(font, Vector2(x- (str(frame).length()-1) * 16, 20), str(frame))
	# 	draw_line(Vector2(x, 20),Vector2(x, h), Color(0.2, 0.2, 0.2), 1)

func _gui_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			_update_time_point(event.position.x)
	if event is InputEventMouseButton and event.is_pressed():
		_update_time_point(event.position.x)

func _update_time_point(new_x: float):
	var snapped_x: float = round(new_x / frame_per_px) * frame_per_px
	snapped_x = clamp(snapped_x, 0, total_width)
	time_point.position.x = snapped_x

	var f := int(snapped_x / frame_per_px)
	var cur_time := float(f) / frame_rate
	frame_changed.emit(cur_time)
	time_point._set_frame_label(f)

var layer = 0
func _add_animation_rect(frame_vector: Vector2):
	layer += 1
	print(frame_vector)
	var animation_rect: AnimationRect = animation_rect_prefab.instantiate()
	add_child(animation_rect)
	animation_rect.position.x = frame_vector.x * frame_per_px
	animation_rect.position.y = layer * 35
	animation_rect.initialize(frame_vector.y * frame_per_px, "position:x")


	

# func _update_time_point(new_x: float):
# 	var cur_frame: int = int(new_x / frame_per_px) + 1
# 	var cur_time: float = float(cur_frame) / frame_rate

# 	frame_changed.emit(cur_time)
# 	time_point.position.x = (cur_frame-1) * frame_per_px
# 	time_point._set_frame_label(cur_frame)
