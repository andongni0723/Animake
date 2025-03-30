extends	Node2D

## Call	this function to show a	hint bar with the given	text
func call_error_hint(_text:	String):
	var	hint_bar_instance :Control	= UIManager.hint_bar.instantiate()
	hint_bar_instance.position = Vector2(20, 570)
	hint_bar_instance.show_hint_bar(_text)
	UIManager.canvas.add_child(hint_bar_instance)
