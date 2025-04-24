class_name TweenWrapper extends RefCounted

# var tween: Tween
var target: BaseObject
var property_path
var from
var to
var duration
var interp
var ease_
var wait_flag := false

func _init(_t, _p, _from, _to, _d, _i, _e, _wait = false):
	target = _t
	property_path = _p
	from = _from
	to = _to
	duration = _d
	interp = _i
	ease_ = _e
	wait_flag = _wait

func wait() -> TweenWrapper:
	wait_flag = true
	return self

func to_data() -> AnimationData:
	var _path = target.get_path().get_concatenated_names().trim_prefix("root/") + ":" + property_path
	# print(duration)
	return AnimationData.new(_path, duration, from, to, interp, ease_, wait_flag)
