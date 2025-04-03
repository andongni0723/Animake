extends	Node2D

var	mouse_position:	Vector2	= Vector2.ZERO

var	dialog:	FileDialog

var is_playing: bool = false

func _ready():
	_create_file_dialog()
	_open_file_dialog()
	UIManager.read_file_button.pressed.connect(_open_file_dialog)
	UIManager.reload_file_button.pressed.connect(_reload_file)

func _physics_process(_delta):
	if is_playing:
		print(is_playing)
	mouse_position = get_global_mouse_position()

# 創建檔案對話框
func _create_file_dialog():
	dialog = FileDialog.new()
	add_child(dialog)
	dialog.visible = false
	
	# 設定對話框屬性
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE  # 使用 file_mode 而不是 mode
	dialog.access =	FileDialog.ACCESS_FILESYSTEM
	dialog.current_path	= "/"

	dialog.title = "選擇檔案"
	dialog.filters = ["*.gd"]  # 只顯示 .gd 檔案
	
	# 連接信號
	dialog.file_selected.connect(_on_file_selected)
	
	# 設定對話框大小
	dialog.popup_centered(Vector2(800, 600))

func _open_file_dialog():
	if not dialog:
		_create_file_dialog()
	
	dialog.visible = true
	_delete_anime_node()


# 當檔案被選擇時的處理函數
func _on_file_selected(path):
	# check	path is .gd	file
	if not path.ends_with(".gd"):
		HintManager.call_error_hint("file is not .gd")
		return

	if is_playing:
		HintManager.call_error_hint("script is playing, please stop it first")
		return

	ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	var	script = load(path).new()
	if script:
		if script.has_method("main"):
			is_playing = true
			await script.main()
			is_playing = false
		else:
			HintManager.call_error_hint("don't have	main() function	in main	script")	
	else:
		HintManager.call_error_hint("can't load	script file")

func _call_script(script):
	script.main()


func _reload_file():
	if not dialog:
		HintManager.call_error_hint("file dialog is not	exist")
		return

	if is_playing:
		HintManager.call_error_hint("script is playing, please stop it first")
		return

	_delete_anime_node()
	await get_tree().create_timer(0.1).timeout
	_on_file_selected(dialog.current_path)
	


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
