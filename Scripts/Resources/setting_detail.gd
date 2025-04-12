class_name SettingDetail extends Resource

@export var properties: Array[SettingProperty] = []

func _init(_pro: Array[SettingProperty] = []) -> void:
    properties = _pro
    pass