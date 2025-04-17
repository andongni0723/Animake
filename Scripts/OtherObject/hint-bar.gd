class_name HintBar extends Control

# @onready var hint_text_label: Label	= $"Bottom/Hint Label"
@export var hint_text_label: Label

## Call	this function to show a	hint bar with the given	text
func show_hint_bar(_title_text: String, _hint_text: String) -> void:
	hint_text_label.text = _title_text + ": " + _hint_text
	var	fade_in	= Core.new_tween()
	fade_in.set_parallel()
	fade_in.tween_property(self, "modulate", Color(1, 1, 1, 1),	0.3)
	fade_in.tween_property(self, "global_position", global_position, 0.3).from(Vector2(20, 570+100))
	await Core.timer(1).timeout
	var	fade_out = Core.new_tween()
	fade_out.set_parallel()
	fade_out.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
	await fade_out.finished
	queue_free()


func _ready():
	_hide()

func _hide():
	modulate.a = 0
