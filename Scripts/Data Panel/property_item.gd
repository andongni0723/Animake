class_name PropertyItem	extends	HBoxContainer

enum PropertyType {
	NUMBER,
	VECTOR2,
	BOOLEAN,
	STRING,
}

@export	var	property_name_label: Label
@export	var	property_value_control_dict: Dictionary[PropertyType, Control]

var	property_name: String =	"Text" :
	set(value):
		property_name_label.text = value
		property_name =	value

var	property_type: PropertyType	= PropertyType.NUMBER


func initialize(_name: String, _type: PropertyType)	-> void:
	property_name =	_name
	property_type =	_type
	if(_type == PropertyType.NUMBER or _type == PropertyType.STRING):
		property_name_label.size_flags_stretch_ratio = 1.3
	property_value_control_dict[_type].visible = true
	pass
