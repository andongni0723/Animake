class_name AnimationRect extends Panel

@export var label: Label

func initialize(end: float, text: String) -> void:
    label.text = text
    size.x = end
    # print("initialize", end, text)