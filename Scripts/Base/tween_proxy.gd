class_name TweenProxy extends RefCounted

var target
var property_path := ""
var final_value
var duration := 0.0
var ease_ := 1.0
var interp := Animation.INTERPOLATION_CUBIC_ANGLE
var wait_ := false

func _init(_t, _p := ""):
	target = _t
	property_path = _p

func _get(property: StringName) -> Variant:
	# 回傳一個新的 Proxy，把路徑累積起來
	var new_path = str(property) if property_path == "" else property_path + ":" + str(property)
	return TweenProxy.new(target, new_path)

func to(val) -> TweenProxy:
	final_value = val
	return self

func ease(_interpolation, _ease: float) -> TweenProxy:
	interp = _interpolation
	ease_ = _ease
	return self

func span(val) -> TweenWrapper:
	duration = val
	var current = target.get_indexed(property_path)
	return TweenWrapper.new(target, property_path, current, final_value, duration, interp, ease_, wait_)
