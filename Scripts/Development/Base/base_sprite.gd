extends	BaseObject
class_name BaseSprite

@onready var sprite: Sprite2D =	$".";
var	color: Color;

@export	var	size: Vector2 =	Vector2.ONE:
	set(value):
		scale =	value
		size = value
		_update_material_size(scale.x, scale.y)
	get():
		return size

@export var sprite_data: SettingDetail = preload("res://Data/Object Data/base_sprite_data.tres")

func _update_material_size(_w: float, _h: float):
	sprite.material.set_shader_parameter("view_width", _w *	100)
	sprite.material.set_shader_parameter("view_height",	_h * 100)


## Tool function 

func get_data() -> Array[SettingProperty]:
	var result = super.get_data()
	result.append_array(sprite_data.properties.duplicate())
	return result

func fade_alpha(_value:float, _time: float)	-> TweenWrapper:
	return Core.tween(self, "modulate:a", _value, _time)

func fade_size(_value: Vector2, _time: float) -> TweenWrapper:
	return Core.tween(self, "size", _value, _time)