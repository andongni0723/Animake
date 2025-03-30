extends	TextureRect

@export	var	choose_image : Control
@export	var	area : Area2D

var _start_mouse_position : Vector2
var _mouse_delta : Vector2
var _is_drag : bool
var	_is_chosen :bool = false

func _gui_input(event: InputEvent) -> void:

	if event.is_action_pressed("left-key") and _is_chosen:
		_start_mouse_position = get_global_mouse_position()
		_is_drag = true

	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		_mouse_delta = get_global_mouse_position() - global_position 

	if event.is_action_released("left-key"):
		_is_chosen = !_is_chosen
		_is_drag = false
		choose_image.visible = _is_chosen
		choose_image.size = size + Vector2.ONE * 30 
		choose_image.position = Vector2.ZERO

	
func _process(_delta):
	if Input.is_action_pressed("delete") and _is_chosen:
		queue_free()

	if Input.is_action_pressed("left-key") and _is_drag:
		global_position = get_global_mouse_position() - _mouse_delta
