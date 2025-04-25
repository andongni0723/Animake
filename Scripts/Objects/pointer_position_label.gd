extends Label

func _process(_delta) -> void:
	var pos = get_global_mouse_position()
	text = "(" + "%0.1f" % pos.x + ", " + "%0.1f" % pos.y + ")"
