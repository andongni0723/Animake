extends	Panel

@export	var	file_item_prefab: PackedScene
@export	var	file_item_container: Control

var	current_open_file_path:	String = ""

func _on_file_id_pressed(id:int) -> void:
	ToolSignal.emit_signal("script_file_menu_pressed", id)

func _enter_tree() -> void:
	ToolSignal.select_folder.connect(_create_file_item)
	ToolSignal._create_new_file_done.connect(_update_file_item)
	pass

func _update_file_item(_new_file_path: String):
	_create_file_item(GameManager.current_project_path)

func _create_file_item(_path: String):
	_delete_all_file_items()
	# Check this folder has main.gd in first-level
	var is_valid := GameManager.get_main_script_path(_path) != ""
	if not is_valid: return

	# Find all .gd files in this folder and create file items
	var	dir	:= DirAccess.open(_path)
	if not dir:	return 
	dir.list_dir_begin()
	while true:
		var	file_name := dir.get_next()
		if file_name == "":	break #	No more	files
		var _path_with_name := _path + "/" + file_name
		if dir.current_is_dir():
			_create_file_item(_path_with_name)
		elif file_name.ends_with(".gd"):
			var	item: FileItem = file_item_prefab.instantiate()
			item.initialize(file_name, _path_with_name)
			file_item_container.add_child(item)


func _delete_all_file_items() -> void:
	for each in file_item_container.get_children():
		file_item_container.remove_child(each)
		each.queue_free()