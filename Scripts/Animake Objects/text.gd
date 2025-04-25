extends BaseObject
class_name Text

var font_size: int = 16:
	set(value):
		font_size = value
		label.set("theme_override_font_sizes/font_size", value)
	get():
		return font_size

var size: Vector2:
	set(value):
		label.size = value
		size = value
	get():
		return label.size

@onready var label: Label = $"Label"

var text_data: SettingDetail = preload("res://Data/Object Property Data/text_data.tres")

func get_data() -> Array[SettingProperty]:
	var result = super.get_data()
	result.append_array(text_data.properties.duplicate())
	return result
