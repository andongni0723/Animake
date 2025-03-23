extends Node2D

var mouse_position: Vector2 = Vector2.ZERO

var dialog: FileDialog

func _ready():
	create_file_dialog()
	open_file_dialog()
	UIManager.read_file_button.pressed.connect(open_file_dialog)


func _physics_process(_delta):
	mouse_position = get_global_mouse_position()

func spawn(prefab: PackedScene, spawn_position: Vector2 = Vector2.ZERO, spawn_rotation: float = 0) -> Node2D:
	var instance := prefab.instantiate()
	instance.position = spawn_position
	instance.rotation = spawn_rotation
	_get_anime_node().add_child(instance)
	return instance

# 創建檔案對話框
func create_file_dialog():
	dialog = FileDialog.new()
	add_child(dialog)
	dialog.visible = false
	
	# 設定對話框屬性
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE  # 使用 file_mode 而不是 mode
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.current_path = "/"

	dialog.title = "選擇檔案"
	dialog.filters = ["*.gd"]  # 只顯示 .gd 檔案
	
	# 連接信號
	dialog.file_selected.connect(_on_file_selected)
	
	# 設定對話框大小
	dialog.popup_centered(Vector2(800, 600))

func open_file_dialog():
	if not dialog:
		create_file_dialog()
	
	dialog.visible = true
	_delete_anime_node()

func new_tween() -> Tween:
	return get_tree().create_tween()

# 當檔案被選擇時的處理函數
func _on_file_selected(path):
	ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	var script = load(path).new()
	if script:
		if script.has_method("main"):
			script.main()
		else:
			print("warning: don't have main() function in main script")
	else:
		printerr("error: can't load script file")


func _get_anime_node() -> Node2D:
	var anime_node := get_node_or_null("/root/Node2D/Anime Node")

	if not anime_node:
		anime_node = Node2D.new()
		get_node("/root/Node2D").add_child(anime_node)
		anime_node.name = "Anime Node"
		
	return anime_node

func _delete_anime_node() -> void:
	var anime_node := get_node("/root/Node2D/Anime Node")
	if anime_node: anime_node.queue_free()
