extends Node

signal select_file(path: String)
signal select_folder(path: String)
signal _create_new_file_done(path: String)

signal rect_tool_left_click

signal script_panel_action(open: bool)
signal call_create_new_script_file()

signal anime_object_add_group_done
signal anime_object_tree_item_click(item: TreeItem)

signal script_file_menu_pressed(id: int)