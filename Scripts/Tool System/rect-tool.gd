extends	Node2D

@export	var	square_prefab: PackedScene
@export	var	ui_square_prefab: PackedScene

@export	var	horizontal_line: Node2D
@export	var	vertical_line: Node2D
@export	var	second_line_parent:	Node2D

@export	var	size_x_label: Label
@export	var	size_y_label: Label



const tool_type: ToolManager.ToolType =	ToolManager.ToolType.RectTool

var	click_time:	int	= 0
var	current_square:	TextureRect

var	start_point: Vector2
var	end_point: Vector2

func _ready():
	horizontal_line.visible	= false
	vertical_line.visible =	false
	second_line_parent.visible = false
	size_x_label.visible = false
	size_y_label.visible = false
	ToolManager.tool_changed.connect(_click_action)
	ToolSignal.rect_tool_left_click.connect(_click_action.bind(tool_type).bind(tool_type))


func _process(_delta):
	_ui_square_action()

	if Input.is_action_just_pressed("cancel"):
		_close_action()

func _click_action(_old_tool: int, _new_tool: int):
	if _new_tool != tool_type:
		_close_action()
		return

	click_time += 1

	if click_time == 1:
		horizontal_line.visible	= true
		vertical_line.visible =	true

	elif click_time	== 2:
		current_square = ui_square_prefab.instantiate()
		UIManager.world_canvas.add_child(current_square)
		start_point	= get_global_mouse_position()
		second_line_parent.visible = true
		second_line_parent.position	= start_point
		size_x_label.visible = true
		size_y_label.visible = true
		size_x_label.position.y = start_point.y
		size_y_label.position.x = start_point.x

	elif click_time	== 3:
		end_point =	get_global_mouse_position()
		_close_action()
		_generate_square()
		click_time = 0 

func _close_action():
	click_time = 0
	horizontal_line.visible	= false
	vertical_line.visible =	false
	second_line_parent.visible = false
	size_x_label.visible = false
	size_y_label.visible = false
	if current_square:
		current_square.queue_free()
		current_square = null

## Adjust the scale of the square based on the start and end points
func adjust_scale(original_scale: float, start_value: float, target_value: float) -> float:
	return -abs(original_scale)	if target_value	< start_value else abs(original_scale)

func _ui_square_action():
	if not current_square:
		return 

	var	mouse_position = get_global_mouse_position()
	current_square.size	= abs(mouse_position - start_point)
	current_square.position	= start_point

	current_square.scale.x = adjust_scale(current_square.scale.x, start_point.x, mouse_position.x)
	current_square.scale.y = adjust_scale(current_square.scale.y, start_point.y, mouse_position.y)


	size_x_label.position.x = start_point.x + (mouse_position.x - start_point.x) / 2
	size_y_label.position.y = start_point.y +  (mouse_position.y - start_point.y) / 2 

	size_x_label.text = "%0.1f" % abs(mouse_position.x - start_point.x)
	size_y_label.text = "%0.1f" % abs(mouse_position.y - start_point.y)


func _generate_square():
	var	square = square_prefab.instantiate()
	square.position	= start_point
	square.size	= abs(end_point	- start_point)
	
	square.scale.x = adjust_scale(square.scale.x, start_point.x, end_point.x)
	square.scale.y = adjust_scale(square.scale.y, start_point.y, end_point.y)
	
	UIManager.world_canvas.add_child(square)
