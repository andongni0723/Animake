class_name ImagePanel extends BaseObject

@export var center: CenterContainer
@export var panel: Panel
@export var panel_data: SettingDetail = preload("res://Data/Object Property Data/panel_data.tres")

var size: Vector2:
    set(value):
        panel.set_deferred("custom_minimum_size", value)
        center.set_deferred("size", value)
        center.set_deferred("pivot_offset", value / 2)
        center.set_deferred("position", -value / 2)
        size = value
    get():
        return size

var radius: float = 0.0:
    set(value):
        radius = value
        var style := panel.get_theme_stylebox("panel")
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

func _ready():
    var stylebox = panel.get_theme_stylebox("panel").duplicate()
    panel.add_theme_stylebox_override("panel", stylebox)
    panel.set_anchors_and_offsets_preset(
        Control.PRESET_CENTER,
        Control.PRESET_MODE_KEEP_SIZE)


func get_data() -> Array[SettingProperty]:
    var result = super.get_data()
    result.append_array(panel_data.properties.duplicate())
    return result


func to_center(container: ImagePanel):
    position = container.size / 2;

func add_style(style_string: String) -> void:
    var styles = style_string.split(' ')
    for style in styles:
        if style.begins_with("pos"):
            position = NodeStyleInterpreter.vector2_interpret("pos", style, position)
        elif style.begins_with("radius"):
            radius = NodeStyleInterpreter.number_interpret("radius", style, radius)
        elif style.begins_with("size"):
            size = NodeStyleInterpreter.vector2_interpret("size", style, size)
        elif style.begins_with("alpha"):
            alpha = NodeStyleInterpreter.number_interpret("alpha", style, alpha)
