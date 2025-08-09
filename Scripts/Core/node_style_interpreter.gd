class_name NodeStyleInterpreter

static var NUMBER_PATTERN  := "-\\/(-?\\d+(?:\\.\\d+)?)\\/"
static var VECTOR2_PATTERN := "-\\/(-?\\d+(?:\\.\\d+)?)\\/-\\/(-?\\d+(?:\\.\\d+)?)\\/"
static var STRING_PATTERN  := "-\\/([^\\/]+)\\/"


static func number_interpret(begin: String, style: String, default_value: float = 0.0) -> float:
    _begin_check(begin, style, default_value)
    var result := _regex_check(style, begin + NUMBER_PATTERN, 1)
    return float(_match_check(result.get_string(1), default_value))


static func vector2_interpret(begin: String, style: String, default_value: Vector2 = Vector2.ZERO) -> Vector2:
    _begin_check(begin, style, default_value)
    var result := _regex_check(style, begin + VECTOR2_PATTERN, 2)
    var x := float(_match_check(result.get_string(1), default_value.x))
    var y := float(_match_check(result.get_string(2), default_value.y))
    return Vector2(x, y)


static func string_interpret(begin: String, style: String, default_value: String = "") -> String:
    _begin_check(begin, style, default_value)
    var result := _regex_check(style, begin + STRING_PATTERN, 1)
    return _match_check(result.get_string(1), default_value)


## Check the style begin with begin
static func _begin_check(begin: String, style: String, default_value):
    if not style.begins_with(begin):
        HintManager.call_error_hint("Invalid " + begin + " style: style not start with: " + begin)
        return default_value


static func _regex_check(style: String, pattern: String, group_count: int) -> RegExMatch:
    var regex = RegEx.new()
    regex.compile(pattern)
    var result = regex.search(style)
    if not result or result.get_group_count() < group_count:
        HintManager.call_error_hint("Invalid " + style + " style: regex not match")
    return result


static func _match_check(value: String, old_value):
    if value.is_empty():
        return old_value
    return value
