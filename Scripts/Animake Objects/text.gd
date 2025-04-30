extends BaseObject
class_name Text

var font_size: int = 16:
    set(value):
        font_size = value
        label.set_deferred("theme_override_font_sizes/font_size", value)
    get():
        return font_size

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

@onready var label: Label = $"Label"

var text_data: SettingDetail = preload("res://Data/Object Property Data/text_data.tres")

func get_data() -> Array[SettingProperty]:
    var result = super.get_data()
    result.append_array(text_data.properties.duplicate())
    return result

func change_parent(new_parent: Node) -> void:
    if get_parent():
        get_parent().remove_child(self)
    new_parent.add_child(self)
