class_name TimePoint extends Control

@export var frame_label: Label


func _set_frame_label(frame: int) -> void:
	frame_label.text = str(frame)