extends	Tree

func _enter_tree() -> void:
	ToolSignal.select_folder.connect(_clear_tree)
	ToolSignal.anime_object_add_group_done.connect(_refresh_node_tree)

func _exit_tree() -> void:
	ToolSignal.select_folder.disconnect(_clear_tree)
	ToolSignal.anime_object_add_group_done.disconnect(_refresh_node_tree)
	clear()

func _on_item_selected() -> void:
	ToolSignal.anime_object_tree_item_click.emit(get_selected())

func _clear_tree(_path: String) -> void:
	clear()

func _refresh_node_tree() -> void:
	clear()
	var	anime_node := GameManager._get_anime_node()
	if not anime_node: return

	# var tree = Tree.new()
	var root := create_item()
	add_node_to_tree(anime_node, root)

func add_node_to_tree(node: Node, parent: TreeItem) -> void:
	for child in node.get_children():
		var item := create_item(parent)
		item.set_text(0, child.name)
		item.set_metadata(0, child)
		add_node_to_tree(child, item)
