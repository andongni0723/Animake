class_name PropertyInput extends HBoxContainer

var _id: String = ""
@export var type: PropertyItem.PropertyType = PropertyItem.PropertyType.NUMBER
@export var value_field: Array[Control] = []

## Call by property_item.gd
func initialize(id: String, _value: Variant):
    _set_field_value(type, _value)
    _id = id
    visible = true

func _set_field_value(_type: PropertyItem.PropertyType, _value: Variant) -> void:
    match(_type):
        PropertyItem.PropertyType.NUMBER:
            value_field[0].value = float(_value)
        PropertyItem.PropertyType.VECTOR2:
            value_field[0].value = float(_value.x)
            value_field[1].value = float(_value.y)
        PropertyItem.PropertyType.BOOLEAN:
            value_field[0].text = str(_value)
        PropertyItem.PropertyType.STRING:
            value_field[0].text = str(_value)

func _update_value_to_object(new_value: Variant):
    PropertyIdTransformer.property_id_to_set_variable(get_parent().object, _id, new_value)
    pass

func _on_text_changed(new_text: String):
    match(type):
        PropertyItem.PropertyType.STRING:
            _update_value_to_object(new_text)

func _on_toggled(toggled_on: bool):
    match(type):
        PropertyItem.PropertyType.BOOLEAN:
            _update_value_to_object(toggled_on)

func _on_value_changed(_value:float) -> void:
    match(type):
        PropertyItem.PropertyType.NUMBER:
            _update_value_to_object(_value)

        PropertyItem.PropertyType.VECTOR2:
            var x = float(value_field[0].value)
            var y = float(value_field[1].value)
            _update_value_to_object(Vector2(x, y))
