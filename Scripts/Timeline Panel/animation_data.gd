class_name AnimationData extends Resource

var key_path: NodePath
var duration: float
var start_value: Variant
var end_value: Variant
var interpolation: Animation.InterpolationType = Animation.INTERPOLATION_LINEAR
var transition: float = 1
var _wait: bool = false

func _init(_key_path: NodePath, _duration: float , _start_value: Variant, _end_value: Variant, _interpolation: Animation.InterpolationType = Animation.INTERPOLATION_LINEAR, _transition: float = 1) -> void:
    key_path = _key_path
    duration = _duration
    start_value = _start_value
    end_value = _end_value
    interpolation = _interpolation
    transition = _transition

func wait() -> AnimationData:
    _wait = true
    return self

func ease_in_out(t: float = -2) -> float:
    return t if t < -1 else -1.01

func linear() -> float:
    return -1

func ease_out_in(t: float = -0.5) -> float:
    return clampf(t, -0.01, -0.99)

func ease_out(t: float = 0.5) -> float:
    return clampf(t, 0.01, 0.99)

func ease_in(t: float = 1) -> float:
    return t if t >= 1.0 else 1.0