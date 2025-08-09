class_name TweenProxy extends RefCounted

var target
var property_path := ""
var start_value = null
var final_value
var duration := 0.0
var ease_ := -2.0
var interp := Animation.INTERPOLATION_CUBIC_ANGLE
var wait_ := false

var use_custom_start_value := false


func _init(_t, _p := ""):
    target = _t
    property_path = _p
    start_value = null
    

## Return a new Proxy, accumulating the property path
func _get(property: StringName) -> Variant:
    var new_path := str(property) if property_path == "" else property_path + ":" + str(property)
    return TweenProxy.new(target, new_path)

func from(val) -> TweenProxy:
    start_value = val
    use_custom_start_value = true
    return self

func to(val) -> TweenProxy:
    final_value = val
    return self

func ease(_ease: float) -> TweenProxy:
    ease_ = _ease
    return self

func span(val) -> TweenWrapper:
    duration = val
#    var current = target.get_indexed(property_path)
#    var start = start_value if use_custom_start_value else null
    return TweenWrapper.new(target, property_path, start_value, final_value, duration, interp, ease_, wait_)
