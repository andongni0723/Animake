class_name PropertyItem	extends	HBoxContainer

enum PropertyType {
    NUMBER,
    VECTOR2,
    BOOLEAN,
    STRING,
}

@export	var	property_name_label: Label
@export	var	property_value_control_dict: Dictionary[PropertyType, PropertyInput]

var	property: SettingProperty =	null
var	object:	BaseObject = null

## Call by data_panel.gd
func initialize(_object: BaseObject, _property:	SettingProperty) -> void:
    property = _property
    object = _object
    property_name_label.text = _property.name
    # if(property.type == PropertyType.NUMBER	or property.type == PropertyType.STRING):
        # property_name_label.size_flags_stretch_ratio = 1.3
    _initial_property_value()
    pass

func _initial_property_value() -> void:
    if not object: return

    # Set input field value 
    var property_value: Variant = PropertyIdTransformer.property_id_to_variable(object, property.id)
    property_value_control_dict[property.type].initialize(property.id, property_value)

    #TODO: change panel value and set object value
