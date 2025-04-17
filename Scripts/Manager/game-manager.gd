extends	Node2D

var	mouse_position:	Vector2	= Vector2.ZERO

var	dialog:	FileDialog

var is_playing: bool = false

func _ready():
	dialog = UIManager.file_dialog_prefab.instantiate()
	add_child(dialog)
	dialog.visible = false
	dialog.dir_selected.connect(_on_folder_selected)
	UIManager.read_file_button.pressed.connect(_open_folder_dialog)
	UIManager.reload_file_button.pressed.connect(_reload_file)

func _physics_process(_delta):
	mouse_position = get_global_mouse_position()

# 創建檔案對話框
# func _create_file_dialog():
# 	# dialog = FileDialog.new()
# 	add_child(dialog)
# 	dialog.visible = false
	
# 	# 設定對話框屬性
# 	# dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE  # 使用 file_mode 而不是 mode
# 	dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
# 	dialog.access =	FileDialog.ACCESS_FILESYSTEM
# 	dialog.current_path	= "/"

# 	dialog.title = "Select a folder which have \"main.gd\""
# 	dialog.filters = ["*.gd"]  # 只顯示 .gd 檔案
	
# 	# 連接信號
# 	dialog.file_selected.connect(_on_folder_selected)
	
# 	# 設定對話框大小
# 	dialog.popup_centered(Vector2(800, 600))

func _open_folder_dialog():
	if is_playing:
		HintManager.call_error_hint("script is playing, please stop it first")
		return
	
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	dialog.access =	FileDialog.ACCESS_FILESYSTEM
	dialog.current_path	= "/"
	dialog.visible = true
	dialog.title = "Select a folder which have \"main.gd\""
	dialog.filters = ["*.gd"]
	_delete_anime_node()


# 當檔案被選擇時的處理函數
func _on_folder_selected(path):
	print("On folder selected")
	ToolSignal.emit_signal("select_folder", path)
	var main_script_path = get_main_script_path(path)
	if main_script_path == "":
		HintManager.call_error_hint("Please make sure \"main.gd\" is located in the top-level folder.")
		return

	var	script = load(main_script_path).new()
	if script:
		if script.has_method("main"):
			is_playing = true
			await script.main()
			is_playing = false
		else:
			HintManager.call_error_hint("don't have	main() function	in main	script")	
	else:
		HintManager.call_error_hint("can't load	script file")

## If not get main script path, return empty string ""
func get_main_script_path(_path: String) -> String:
	# Check folder depth
	var dir := DirAccess.open(_path)
	if not dir: 
		HintManager.call_error_hint("ERROR: Can't open this folder")
		return ""
	
	dir.list_dir_begin()
	while true:
		var file_name := dir.get_next()
		if file_name == "": break # No more files

		var _path_with_name := _path + "/" + file_name
		if file_name == "main.gd":
			return _path_with_name
	return ""

func _reload_file():
	if is_playing:
		HintManager.call_error_hint("script is playing, please stop it first")
		return

	_delete_anime_node()
	await get_tree().create_timer(0.1).timeout
	_on_folder_selected(dialog.current_path)
	
func _get_anime_node() -> Node2D:
	var	anime_node := get_node_or_null("/root/Node2D/Anime Node")
	if not anime_node:
		anime_node = Node2D.new()
		get_node("/root/Node2D").add_child(anime_node)
		anime_node.name	= "Anime Node"
		
	return anime_node

func _delete_anime_node() -> void:
	var	anime_node := get_node_or_null("/root/Node2D/Anime Node")
	if anime_node: anime_node.queue_free()
