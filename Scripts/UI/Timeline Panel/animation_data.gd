class_name AnimationData extends Resource

var key_path: NodePath
var duration: float
var from: Variant = null
var to: Variant
var interp: Animation.InterpolationType = Animation.INTERPOLATION_CUBIC
var ease_: float = 1.0
var wait: bool = false
var null_anim: bool = false
var default_from: Variant

func _init(_p, _d , _f, _t, _i, _e, _w = false, _n = false, _d_f = null) -> void:
    key_path = _p
    duration = _d
    from = _f
    to = _t
    interp = _i
    ease_ = _e
    wait = _w
    null_anim = _n
    default_from = _d_f