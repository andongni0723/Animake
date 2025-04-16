extends	Node2D

## Call	this function to show a	hint bar with the given	text
func call_error_hint(_text:	String):
	_show_hint_action(UIManager.error_hint_bar, _text)

func call_normal_hint(_text: String):
	_show_hint_action(UIManager.normal_hint_bar, _text)

func _show_hint_action(prefab: PackedScene, text: String):
	var hint_bar_instance: HintBar = prefab.instantiate()
	hint_bar_instance.position = Vector2(20, 570)
	hint_bar_instance.show_hint_bar(text)
	UIManager.canvas.add_child(hint_bar_instance)