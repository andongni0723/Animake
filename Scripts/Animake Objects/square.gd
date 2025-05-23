extends BaseSprite
class_name Square

var radius: float = 0.0:
    set(value):
        radius = value
        sprite.material.set_shader_parameter("rounded_radius", value)

@export var square_data: SettingDetail = preload("res://Data/Object Property Data/square_data.tres")

func _ready():
    sprite.material = sprite.material.duplicate()
    _update_material_size(scale.x, scale.y)

func _update_material_size(_w: float, _h: float):
    sprite.material.set_shader_parameter("view_width", _w * 100)
    sprite.material.set_shader_parameter("view_height", _h * 100)

func get_data() -> Array[SettingProperty]:
    var result = super.get_data()
    result.append_array(square_data.properties.duplicate())
    return result

func add_style(style_string: String) -> void:
    var styles = style_string.split(' ')
    for style in styles:
        if style.begins_with("pos"):
            position = NodeStyleInterpreter.vector2_interpret("pos", style, position)
        elif style.begins_with("rounded"):
            radius = NodeStyleInterpreter.number_interpret("radius", style, radius)
        elif style.begins_with("scale"):
            scale = NodeStyleInterpreter.vector2_interpret("scale", style, scale)
