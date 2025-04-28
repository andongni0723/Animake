class_name ImagePanel extends BaseObject

@onready var center: CenterContainer = $"Center"
@onready var panel: Panel = $"Center/panel"
@export var panel_data: SettingDetail = preload("res://Data/Object Property Data/panel_data.tres")

var size: Vector2:
    set(value):
        panel.set_deferred("custom_minimum_size", value)
        center.set_deferred("size", value)
        center.set_deferred("pivot_offset", value / 2)
        center.set_deferred("position", -value / 2)
        size = value
        # panel.custom_minimum_size = value
        # center.size = value
        # center.pivot_offset = value / 2
        # center.position = -center.size / 2
        # size = value
    get():
        return panel.custom_minimum_size

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

func add_style(style_string: String) -> void:
    var styles = style_string.split(' ')
    for style in styles:
        if style.begins_with("pos"):
            # position = NodeStyleInterpreter.position_interpret(style)
            position = NodeStyleInterpreter.vector2_interpret("pos", style, position)
        elif style.begins_with("radius"):
            radius = NodeStyleInterpreter.number_interpret("radius", style, radius)
            # radius = NodeStyleInterpreter.rounded_radius_interpret(style)
        elif style.begins_with("size"):
            size = NodeStyleInterpreter.vector2_interpret("size", style, size)
            # size = NodeStyleInterpreter.size_interpret(style)
        elif style.begins_with("alpha"):
            alpha = NodeStyleInterpreter.number_interpret("alpha", style, alpha)
