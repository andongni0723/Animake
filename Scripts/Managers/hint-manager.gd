extends	Node2D

## Call	this function to show a	hint bar with the given	text
func call_error_hint(_text:	String):
	_show_hint_action(UIManager.error_hint_bar, "ERROR", _text)


func call_normal_hint(_text: String):
	_show_hint_action(UIManager.normal_hint_bar, "NORMAL", _text)


func _show_hint_action(prefab: PackedScene, head_text: String, text: String):
	var hint_bar_instance: HintBar = prefab.instantiate()
	var screen_y = get_viewport_rect().size.y
	hint_bar_instance.position = Vector2(20, screen_y - 80)
	hint_bar_instance.z_index = 100
	hint_bar_instance.show_hint_bar(head_text, text)
	UIManager.canvas.add_child(hint_bar_instance)
