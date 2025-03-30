extends Node2D
class_name UIManager

@export var _read_file_button: BaseButton
static var read_file_button: BaseButton

@export var _reload_file_button: BaseButton
static var reload_file_button: BaseButton

@export var _canvas: CanvasLayer
static var canvas: CanvasLayer

@export var _world_canvas: CanvasLayer
static var world_canvas: CanvasLayer

@export var _hint_bar: PackedScene
static var hint_bar: PackedScene

@export_category("Tool Buttons")
@export var _rect_tool_button: BaseButton
static var rect_tool_button: BaseButton

func _enter_tree() -> void:
	read_file_button = _read_file_button
	reload_file_button = _reload_file_button
	canvas = _canvas
	world_canvas = _world_canvas
	hint_bar = _hint_bar
	rect_tool_button = _rect_tool_button