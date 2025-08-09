class_name Text extends BaseObject

@export var label: Label

var font_size: int = 16:
    set(value):
        font_size = value
        label.set_deferred("theme_override_font_sizes/font_size", value)
    get():
        return font_size

var font_weight: int = 400:
    set(value):
        value = clampi(value, 1, 1000)
        var fv = FontVariation.new()
        fv.base_font = load("res://Font/JetBrainsMono-VariableFont_wght.ttf")
        var tag := TextServerManager.get_primary_interface().name_to_tag("wght")
        var axes: Dictionary = fv.variation_opentype
        axes[tag] = value
        fv.variation_opentype = axes
        label.set("theme_override_fonts/font", fv)
        font_weight = value
    get():
        return font_weight

var size: Vector2:
    set(value):
        # label.size = value
        label.set_deferred("size", value)
        label.position = Vector2.ZERO
        size = value
    get():
        return size

var alpha: float = 1:
    set(value):
        label.self_modulate.a = value
        alpha = value
    get():
        return alpha

var text_data: SettingDetail = preload("res://Data/Object Property Data/text_data.tres")

func get_data() -> Array[SettingProperty]:
    var result := super.get_data()
    result.append_array(text_data.properties.duplicate())
    return result

func change_parent(new_parent: Node) -> void:
    if get_parent():
        get_parent().remove_child(self)
    new_parent.add_child(self)

func add_style(style_string: String) -> void:
    var styles := style_string.split(' ')
    for style in styles:
        if style.begins_with("pos"):
            position = NodeStyleInterpreter.vector2_interpret("pos", style, position)
        elif style.begins_with("size"):
            size = NodeStyleInterpreter.vector2_interpret("size", style, size)    
        elif style.begins_with("font_size"):
            font_size = int(NodeStyleInterpreter.number_interpret("font_size", style, font_size))
        elif style.begins_with("weight"):
            font_weight = int(NodeStyleInterpreter.number_interpret("weight", style, font_weight))
        elif style.begins_with("alpha"):
            alpha = NodeStyleInterpreter.number_interpret("alpha", style, alpha)
        elif style.begins_with("text"):
            label.text = NodeStyleInterpreter.string_interpret("text", style, label.text)
