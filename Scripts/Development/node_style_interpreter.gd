class_name NodeStyleInterpreter

static var POSITION_PATTERN = "pos-\\/((-?\\d+|))\\/-\\/((-?\\d+|))\\/"
static var SCALE_PATTERN = "scale-\\/((-?\\d+|))\\/-\\/((-?\\d+|))\\/"
static var ROUNDED_PATTERN = "rounded-\\/(\\d+)\\/"


static func position_interpret(regex: String, default_vector: Vector2 = Vector2.ZERO) -> Vector2:
    if not regex.begins_with("pos"):
        printerr("Invalid position style: style not start with pos")
        return default_vector
        
    var regex_obj = RegEx.new()
    regex_obj.compile(POSITION_PATTERN)
    var result = regex_obj.search(regex)
    
    if not result or result.get_group_count() < 3:
        printerr("Invalid position style: regex not match")
        return default_vector
    
    var x = _match_check(result.get_string(1), default_vector.x)
    var y = _match_check(result.get_string(3), default_vector.y)
    
    return Vector2(x, y)


static func size_interpret(regex: String, default_vector: Vector2 = Vector2.ONE) -> Vector2:
    if not regex.begins_with("scale"):
        printerr("Invalid scale style: style not start with scale")
        return default_vector
    
    var regex_obj = RegEx.new()
    regex_obj.compile(SCALE_PATTERN)
    var result = regex_obj.search(regex)
    
    if not result or result.get_group_count() < 1:
        printerr("Invalid scale style: regex not match")
        return default_vector
    
    var x = _match_check(result.get_string(1), default_vector.x)

    if result.get_string(2).is_empty(): # scale-/10/
        return Vector2.ONE * x  
        
    var y = _match_check(result.get_string(3), default_vector.y)

    print("scale ", result.get_string(1), " ", result.get_string(3));
    
    return Vector2(x, y)  # scale-/10/-/20/

static func rounded_radius_interpret(regex: String, default_radius: float = 0.0) -> float:
    if not regex.begins_with("rounded"):
        printerr("Invalid rounded style: style not start with rounded")
        return 0.0
    
    var regex_obj = RegEx.new()
    regex_obj.compile(ROUNDED_PATTERN)
    var result = regex_obj.search(regex)
    
    if not result or result.get_group_count() < 1:
        printerr("Invalid rounded style: regex not match")
        return 0.0
    
    return _match_check(result.get_string(1), default_radius)

static func _match_check(value: String, old_value: float) -> float:
    if value.is_empty():
        return old_value
    return float(value)