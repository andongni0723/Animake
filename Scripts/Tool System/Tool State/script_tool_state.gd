extends BaseToolState

func enter_state() -> void:
    ToolSignal.emit_signal("script_panel_action", true)

func exit_state() -> void:
    ToolSignal.emit_signal("script_panel_action", false)