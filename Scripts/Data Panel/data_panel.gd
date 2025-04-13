extends	PanelContainer

@export	var	property_prefab: PackedScene
@export	var	v_box: VBoxContainer

func _enter_tree() -> void:
	ToolSignal.anime_object_tree_item_click.connect(_show_property_detail)

func _exit_tree() -> void:
	ToolSignal.anime_object_tree_item_click.disconnect(_show_property_detail)

func _show_property_detail(_item: TreeItem):
	_clear_v_box()
	# Object Path : AnimeNode + TreeItem Path
	var	node_path_str: String	= str(GameManager._get_anime_node().get_path()) + _get_full_tree_item_path(_item)
	var	node: Node = get_node(NodePath(node_path_str))
	var object: BaseObject = node as BaseObject

	if object: _create_property_node(SettingDetail.new(object.get_data()), object)

func _create_property_node(data: SettingDetail, object: BaseObject):
	for	property : SettingProperty in data.properties:
		var	property_node: PropertyItem = property_prefab.instantiate()
		v_box.add_child(property_node)
		property_node.initialize(object, property)

func _clear_v_box():
	for	child in v_box.get_children().duplicate():
		v_box.remove_child(child)
		child.queue_free()

func _get_full_tree_item_path(item: TreeItem) -> String:
	var result: String = ""
	var current_item: TreeItem = item
	while current_item:
		var item_name: String = current_item.get_text(0)
		if item_name != "":
			result = "/" + item_name + result
		current_item = current_item.get_parent()
	return result
	
