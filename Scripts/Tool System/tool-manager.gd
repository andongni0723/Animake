extends	Node

# signal rect_tool_left_click
signal tool_changed(_old_tool: ToolType, _new_tool: ToolType)

enum ToolType {None, RectTool, ScriptTool}
var	current_tool: ToolType;
var current_tool_state: BaseToolState

var _tool_states_dict = {
	ToolType.None: preload("res://Scripts/Tool System/Tool State/none_state.gd").new(),
	ToolType.RectTool: preload("res://Scripts/Tool System/Tool State/rect_tool_state.gd").new(),
	ToolType.ScriptTool: preload("res://Scripts/Tool System/Tool State/script_tool_state.gd").new()
}

func _ready() -> void:
	current_tool = ToolType.None
	current_tool_state = _tool_states_dict[current_tool]
	_connect_ui_button()	

func _process(_delta) -> void:
	if current_tool_state:
		current_tool_state.process(_delta)

func _change_tool(_tool_id: ToolType):
	# Close tool
	if current_tool == _tool_id:
		emit_signal("tool_changed", _tool_id, ToolType.None)
		_change_state(current_tool, ToolType.None)
	else:
		emit_signal("tool_changed", current_tool, _tool_id)
		_change_state(current_tool, _tool_id)

func _change_state(_old_tool: ToolType, _new_tool: ToolType) -> void:
	if _old_tool == _new_tool: return 

	if current_tool_state:
		current_tool_state.exit_state()

	if _tool_states_dict.has(_new_tool):
		current_tool_state = _tool_states_dict[_new_tool]
		current_tool = _new_tool
		current_tool_state.enter_state()
	else:
		HintManager.call_error_hint("Tool not found: " + str(_new_tool))
	

# func _rect_tool():
	# _change_tool(ToolType.RectTool)

func _connect_ui_button() -> void:
	UIManager.rect_tool_button.pressed.connect(_change_tool.bind(ToolType.RectTool))
	UIManager.script_tool_button.pressed.connect(_change_tool.bind(ToolType.ScriptTool))
