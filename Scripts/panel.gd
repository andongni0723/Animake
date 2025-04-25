class_name ImagePanel extends BaseObject

@onready var panel: Panel = $"panel"
@export var panel_data: SettingDetail = preload("res://Data/Object Property Data/panel_data.tres")

var size: Vector2: 
	set(value):
		panel.size = value
		size = value
	get():
		return panel.size
	
var radius: float = 0.0:
	set(value):
		radius = value
		var style := panel.get_theme_stylebox("panel")  # "panel" 是對應 Panel 預設的 style name
		if style is StyleBoxFlat:
			style.set_corner_radius_all(value)
	get():
		return radius

var color: Color = Color.WHITE:
	set(value):
		panel.modulate = value
		color = value
	get():
		return color;

var self_color: Color = Color.WHITE:
	set(value):
		panel.self_modulate = value
		self_color = value
	get():
		return self_color

var alpha: float = 1.0:
	set(value):
		panel.modulate.a = value
		alpha = value
	get():
		return alpha

func get_data() -> Array[SettingProperty]:
	var result = super.get_data()
	result.append_array(panel_data.properties.duplicate())
	return result


func add_style(style_string: String) -> void:
	var styles = style_string.split(' ')
	for style in styles:
		if style.begins_with("pos"):
			position = NodeStyleInterpreter.position_interpret(style)
		elif style.begins_with("rounded"):
			radius = NodeStyleInterpreter.rounded_radius_interpret(style)
		elif style.begins_with("size"):
			size = NodeStyleInterpreter.size_interpret(style)
