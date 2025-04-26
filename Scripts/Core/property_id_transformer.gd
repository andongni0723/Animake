class_name PropertyIdTransformer

static func property_id_to_variable(object: BaseObject, _property_id: String) -> Variant:
    return object.get_indexed(_property_id)

static func property_id_to_set_variable(object: BaseObject, _property_id: String, value: Variant) -> void:
    object.set_indexed(_property_id, value)