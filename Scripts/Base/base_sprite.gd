extends BaseObject
class_name BaseSprite

@onready var sprite: Sprite2D = $".";

var color: Color = Color.WHITE:
    set(value):
        sprite.modulate = value
        color = value
    get():
        return color;

var self_color: Color = Color.WHITE:
    set(value):
        sprite.self_modulate = value
        self_color = value
    get():
        return self_color

var alpha: float = 1.0:
    set(value):
        sprite.modulate.a = value
        alpha = value
    get():
        return alpha

@export var sprite_data: SettingDetail = preload("res://Data/Object Property Data/base_sprite_data.tres")

func _update_material_size(_w: float, _h: float):
    sprite.material.set_shader_parameter("view_width", _w * 100)
    sprite.material.set_shader_parameter("view_height", _h * 100)

#region Tool function
func get_data() -> Array[SettingProperty]:
    var result = super.get_data()
    result.append_array(sprite_data.properties.duplicate())
    return result

func fade_alpha(_value:float, _time: float) -> TweenWrapper:
    return Core.tween(self, "alpha", _value, _time)

func fade_size(_value: Vector2, _time: float) -> TweenWrapper:
    return Core.tween(self, "size", _value, _time)
#endregion
