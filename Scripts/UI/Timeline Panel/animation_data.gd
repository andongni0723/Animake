class_name AnimationData extends Resource

var key_path: NodePath
var duration: float
var from: Variant
var to: Variant
var interp: Animation.InterpolationType = Animation.INTERPOLATION_CUBIC
var ease_: float = 1.0
var wait: bool = false

var null_anim: bool = false

func _init(_p, _d , _f, _t, _i, _e, _w = false, _n = false) -> void:
    key_path = _p
    duration = _d
    from = _f
    to = _t
    interp = _i
    ease_ = _e
    wait = _w
    null_anim = _n

# func wait() -> AnimationData:
#     wait = true
#     return self

# func ease_in_out(t: float = -2) -> float:
#     return t if t < -1 else -1.01

# func linear() -> float:
#     return -1

# func ease_out_in(t: float = -0.5) -> float:
#     return clampf(t, -0.01, -0.99)

# func ease_out(t: float = 0.5) -> float:
#     return clampf(t, 0.01, 0.99)

# func ease_in(t: float = 1) -> float:
#     return t if t >= 1.0 else 1.0
