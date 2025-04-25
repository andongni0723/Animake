extends	CodeEdit

var	function_names:	Array[String] =	\
["print", "make_square", "add_style", "wait", "tween_pos_x", "tween_pos_y", "tween_pos"]
var	class_names: PackedStringArray = \
["Core", "Create", "Square", "Text", "BaseSprite", "BaseObject", "NodeStyleInterpreter"]
var keyword_list: Array[String] = \
["and","as","await","break","class_name","const","continue",
"elif","else","export","extends","false","for","func","if","in","is","match","not","null",
"onready","or","pass","return","signal","static","tool","true","var","while","yield"]

var	_current_file: FileAccess = null
var _current_file_path: String = ""
var	_dialog: FileDialog = null

func _enter_tree() -> void:
	ToolSignal.connect("select_folder", _initialize)
	ToolSignal.connect("select_file", _open_file)
	ToolSignal.connect("script_file_menu_pressed", _file_menu_action)

func _exit_tree() -> void:
	ToolSignal.disconnect("select_file", _open_file)
	ToolSignal.disconnect("script_file_menu_pressed", _file_menu_action)

func _ready():
	_create_dialog()
	pass

func _create_dialog():
	if _dialog != null: return
	_dialog = UIManager.file_dialog_prefab.instantiate()
	add_child(_dialog)
	_dialog.visible = false
	_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	_dialog.access = FileDialog.ACCESS_FILESYSTEM
	_dialog.current_path = "/"
	_dialog.title = "Create a new script file"
	_dialog.filters = ["*.gd"]
	_dialog.file_selected.connect(_create_new_file_action)


func _initialize(_p: String) -> void:
	_current_file = null
	text = ""

func _on_code_completion_requested():		
	for	each in function_names:
		add_code_completion_option(CodeEdit.KIND_FUNCTION, each, each+"(",	syntax_highlighter.function_color)
	for	each in class_names:
		add_code_completion_option(CodeEdit.KIND_VARIABLE, each, each, Color(0.847059, 0.709804, 0.462745, 1))
	for	each in keyword_list:
		add_code_completion_option(CodeEdit.KIND_FUNCTION, each, each, Color(0.9, 0.6, 1, 1))
	update_code_completion_options(true)

func _open_file(_file_path: String) -> void:
	if _current_file: _save_file()
	if not _file_path.ends_with(".gd"): return
	_current_file = FileAccess.open(_file_path, FileAccess.READ)
	_current_file_path = _file_path
	text = _current_file.get_as_text()
	pass

func _file_menu_action(id: int):
	if id == 0: # Create
		_create_new_file()
	if id == 1: # Save
		_save_file()

var file_dialog : FileDialog = null

func _create_new_file() -> void:
	if GameManager.current_project_path == "": return
	_dialog.visible = true
	_dialog.current_path = GameManager.current_project_path
	_dialog.current_dir = GameManager.current_project_path
	pass

func _create_new_file_action(_new_file_path: String) -> void:
	var file = FileAccess.open(_new_file_path, FileAccess.WRITE)
	if file == null:
		HintManager.call_error_hint("Can't create file")
		return
	file.store_string("func main():\n\tpass\n")
	file.close()
	ToolSignal.emit_signal("_create_new_file_done", _new_file_path)
	pass

func _save_file() -> void:
	if not _current_file: return
	_current_file = FileAccess.open(_current_file_path, FileAccess.WRITE)
	_current_file.store_string(text)
	HintManager.call_normal_hint("File saved")

# func print_custom_classes()	-> void:
# 	var	custom_classes = ProjectSettings.get_setting("application/config/script_classes")
# 	print(custom_classes)
# 	if custom_classes:
# 		for	n in custom_classes.keys():
# 			print(n)
# 	else:
# 		print("No custom classes defined.")
