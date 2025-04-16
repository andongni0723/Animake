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

@export var _normal_hint_bar: PackedScene
static var normal_hint_bar: PackedScene

@export var _error_hint_bar: PackedScene
static var error_hint_bar: PackedScene

@export var _script_panel: Control
static var script_panel: Control

@export_category("Tool Buttons")
@export var _rect_tool_button: BaseButton
static var rect_tool_button: BaseButton

@export var _script_tool_button: BaseButton
static var script_tool_button: BaseButton

func _enter_tree() -> void:
	read_file_button = _read_file_button
	reload_file_button = _reload_file_button
	canvas = _canvas
	world_canvas = _world_canvas
	normal_hint_bar = _normal_hint_bar
	error_hint_bar = _error_hint_bar
	rect_tool_button = _rect_tool_button
	script_tool_button = _script_tool_button
	script_panel = _script_panel
	ToolSignal.connect("script_panel_action", _open_script_panel)

func _open_script_panel(open: bool) -> void:
	script_panel.visible = open
