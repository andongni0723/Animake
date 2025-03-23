extends Label

func _process(_delta) -> void:
	text = "Pointer Position: " +  str(GameManager.mouse_position)
