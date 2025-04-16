extends	CodeEdit

var	function_names:	Array[String] =	\
["print", "make_square", "add_style", "wait", "tween_pos_x", "tween_pos_y", "tween_pos"]
var	class_names: PackedStringArray = \
["Core", "Create", "Square", "Text", "BaseSprite", "BaseObject", "NodeStyleInterpreter"]
var keyword_list: Array[String] = \
["and","as","await","break","class_name","const","continue",
"elif","else","export","extends","false","for","func","if","in","is","match","not","null",
"onready","or","pass","return","signal","static","tool","true","var","while","yield"]

var	file: FileAccess = null
var path: String = ""

func _enter_tree() -> void:
	ToolSignal.connect("select_file", _open_file)
	ToolSignal.connect("script_file_menu_pressed", _file_menu_action)

func _exit_tree() -> void:
	ToolSignal.disconnect("select_file", _open_file)
	ToolSignal.disconnect("script_file_menu_pressed", _file_menu_action)

func _ready():
	# class_names = ClassDB.get_class_list()
	pass

func _on_code_completion_requested():		
	for	each in function_names:
		add_code_completion_option(CodeEdit.KIND_FUNCTION, each, each+"(",	syntax_highlighter.function_color)
	for	each in class_names:
		add_code_completion_option(CodeEdit.KIND_VARIABLE, each, each, Color(0.847059, 0.709804, 0.462745, 1))
	for	each in keyword_list:
		add_code_completion_option(CodeEdit.KIND_FUNCTION, each, each, Color(0.9, 0.6, 1, 1))
	update_code_completion_options(true)

func _open_file(_path: String) -> void:
	if not _path.ends_with(".gd"): return
	file = FileAccess.open(_path, FileAccess.READ)
	path = _path
	text = file.get_as_text()
	pass

func _file_menu_action(id: int):
	if id == 1: # Save
		if not file: return
		file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(text)
		HintManager.call_normal_hint("NORMAL: File saved")

func print_custom_classes()	-> void:
	var	custom_classes = ProjectSettings.get_setting("application/config/script_classes")
	print(custom_classes)
	if custom_classes:
		for	n in custom_classes.keys():
			print(n)
	else:
		print("No custom classes defined.")
