class_name TimelinePanel extends Control

@export var animation_player: AnimationPlayer
@export var timeline_canvas: TimelineCanvas
@export var play_button: Button
@export var stop_button: Button

var _animation_data_array: Array[AnimationData]

var _anim_name := "timeline_anim"
var _library: AnimationLibrary
var _anim: Animation = Animation.new()

func _enter_tree() -> void:
	timeline_canvas.frame_changed.connect(_on_frame_changed)
	ToolSignal.select_folder.connect(_clear_array)
	play_button.pressed.connect(play_animation)
	stop_button.pressed.connect(stop_animation)
	animation_player.root_node = get_tree().root.get_path()

func _exit_tree() -> void:
	ToolSignal.select_folder.disconnect(_clear_array)

func _ready():
	# var node = Create.make_square("square")
	# node.change_parent(self)
	# node.pos_y = -200
	_library = animation_player.get_animation_library("")
	# _anim = Animation.new()
	
	_animation_initialize()
	# call_add_animation("square:position:x", Vector2(0, 2), -200, 200)
	animation_player.play(_anim_name, 0.0)
	animation_player.stop()
	# Debug 用：印出所有註冊過的 Library 及 Animation
	print("Libraries:", animation_player.get_animation_library_list())
	print("Animations:", animation_player.get_animation_list())

	

func _animation_initialize():
	_library.add_animation(_anim_name, _anim)

func _clear_array(_p):
	_animation_data_array.clear()
	animation_player.stop()
	_anim.clear()

var time := 0.0
func add_animation_data(_animation_data: AnimationData):
	_animation_data_array.append(_animation_data)
	call_add_animation(_animation_data.key_path, Vector2(time, _animation_data.duration), _animation_data.from, _animation_data.to)
	time += _animation_data.duration if _animation_data.wait else 0.0
	timeline_canvas._update_animation_rect(_animation_data_array)

func call_add_animation(_path: String, _time: Vector2, _start_value: Variant, _end_value: Variant):
	print("ADD")
	var track_id = _anim.add_track(Animation.TYPE_VALUE)
	_anim.track_set_path(track_id, _path)
	_anim.track_insert_key(track_id, _time.x, _start_value)
	_anim.track_insert_key(track_id, _time.y, _end_value)
	_anim.length += _time.y

func stop_animation():
	animation_player.stop()

func play_animation():
	animation_player.play(_anim_name, 0.0)
	# for i in _animation_data_array:
		# print("AnimationData:", i.key_path, " ", i.duration, " ", i.from, " ", i.to," ", i.wait)

func _on_frame_changed(new_time: float):
	animation_player.seek(new_time, true)
