extends MenuBar

@export var _file_menu: PopupMenu
# @export var _edit_menu: PopupMenu


func _ready():
	_initialize()
	pass

func _initialize():
	var ev = InputEventKey.new()
	ev.keycode = KEY_S
	ev.command_or_control_autoremap = true
	var sh = Shortcut.new()
	sh.events.append(ev)
	_file_menu.set_item_shortcut(1, sh)
