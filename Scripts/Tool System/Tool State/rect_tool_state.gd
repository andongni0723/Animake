extends BaseToolState

func process(_delta):
    if Input.is_action_just_pressed("left-key"):
        # Emit signal to tool manager
        ToolSignal.emit_signal("rect_tool_left_click")