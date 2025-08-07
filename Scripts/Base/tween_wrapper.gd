class_name TweenWrapper extends RefCounted

# var tween: Tween
var target: BaseObject
var property_path: String
var from = null
var to
var duration
var interp: int = Animation.INTERPOLATION_CUBIC
var ease_ := 1.0
var wait_flag := false

var null_anim: bool = false

func _init(_t, _p, _from, _to, _d, _i, _e, _wait = false, _n = false):
    target = _t
    property_path = _p
    from = _from
    to = _to
    duration = _d
    interp = _i
    ease_ = _e
    wait_flag = _wait
    null_anim = _n

func set_skip(_skip: bool) -> TweenWrapper:
    null_anim = _skip
    return self

func wait() -> TweenWrapper:
    wait_flag = true
    return self

func to_data() -> AnimationData:
    var _path := ""
    if not null_anim:
        _path = target.get_path().get_concatenated_names().trim_prefix("root/") + ":" + property_path
    var default_from = null if not target else target.get_indexed(property_path) 
    return AnimationData.new(_path, duration, from, to, interp, ease_, wait_flag, null_anim, default_from)
