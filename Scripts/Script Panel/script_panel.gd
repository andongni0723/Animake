extends Panel

func _on_file_id_pressed(id:int) -> void:
    ToolSignal.emit_signal("script_file_menu_pressed", id)