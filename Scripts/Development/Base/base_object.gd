extends Node2D
class_name BaseObject

var pos_x: float = 0.0:
	set(value):
		pos_x = value
		position.x = value
	get:
		pos_x = position.x
		return pos_x

var pos_y: float = 0.0:
	set(value):
		pos_y = value
		position.y = value
	get:
		pos_y = position.y
		return pos_y
