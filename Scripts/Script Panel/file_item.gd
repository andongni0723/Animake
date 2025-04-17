class_name FileItem	extends	Button

@export	var	label: Label
var	file_name: String =	"" :
	set(value):
		file_name =	value
		label.text = value

var	path: String = ""

func initialize(_name: String, _path: String) -> void:
	file_name =	_name
	path = _path

## Open the file
func _on_pressed() -> void:
	if path == "": return
	ToolSignal.emit_signal("select_file", path)