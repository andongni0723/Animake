extends Label


func _ready():
    ToolManager.tool_changed.connect(_update_text)
    pass


func _update_text(_old_tool: int, _new_tool: int) -> void:
    text = "Current Tool: " + str(_new_tool)