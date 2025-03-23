extends Node2D
class_name UIManager

@export var _read_file_button: BaseButton
static var read_file_button: BaseButton

@export var _reload_file_button: BaseButton
static var reload_file_button: BaseButton

func _enter_tree() -> void:
	read_file_button = _read_file_button
	reload_file_button = _reload_file_button