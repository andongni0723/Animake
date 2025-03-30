extends Sprite2D

@export var lock_x: bool = false
@export var lock_y: bool = false

func _process(_delta):
	if is_visible_in_tree():
		var mouse_pos := get_global_mouse_position()
		global_position = Vector2(mouse_pos.x if not lock_x else position.x, mouse_pos.y if not lock_y else position.y)
