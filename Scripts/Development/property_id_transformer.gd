class_name PropertyIdTransformer

static func property_id_to_variable(object: BaseObject, _property_id: String) -> Variant:
	match _property_id:
		"position":
			return object.position
		"position.x":
			return object.position.x
		"position.y":
			return object.position.y
		"border_radius":
			return object.radius
		"size":
			return object.size
		"size.x":
			return object.size.x
		"size.y":
			return object.size.y
		"text":
			return object.label.text
		_:
			HintManager.call_error_hint("Unknown property id: " + _property_id)
			return null

static func property_id_to_set_variable(object: BaseObject, _property_id: String, value: Variant) -> void:
	match _property_id:
		"position":
			object.position = value
		"position.x":
			object.position.x = value
		"position.y":
			object.position.y = value
		"border_radius":
			object.radius = value
		"size":
			object.size = value
		"size.x":
			object.size.x = value
		"size.y":
			object.size.y = value
		"text":
			object.label.text = value
		_:
			HintManager.call_error_hint("Unknown property id: " + _property_id)