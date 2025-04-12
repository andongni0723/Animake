extends	BaseObject
class_name Text

# var text:	String = "" :
#	set(value):
#		text = value
#		label.text = value

@onready var label:	Label =	$"Label"

var	text_data: SettingDetail = preload("res://Data/Object Data/text_data.tres")

func get_data()	-> Array[SettingProperty]:
	var	result = super.get_data()
	result.append_array(text_data.properties.duplicate())
	return result