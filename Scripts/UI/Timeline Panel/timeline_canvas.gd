class_name TimelineCanvas extends Control

@export var font: Font
@export var canvas: Control
@export var duration: float = 10
@export var frame_rate: int = 30
@export var frame_per_px: float = 20
@export var interval_frame: int = 4
@export var keyframes: Array[Vector2]
@export var time_point: TimePoint
@export var animation_rect_prefab: PackedScene
@export var animation_rect_parent: Control

signal frame_changed(new_time: float)

var total_width: float
var current_time: float = 0.0

func _ready():
    total_width = frame_rate * (duration + 1) * frame_per_px
    custom_minimum_size.x = total_width

    _update_time_point(0)

func _draw() -> void:
    print("draw")
    var h = canvas.size.y

    # Draw the background: frame number and lines
    for f in range(0, int(frame_rate * duration) + 1, interval_frame):
        var x = f * frame_per_px
        var text = str(f)
        var text_w = font.get_string_size(text).x
        draw_string(font, Vector2(x - (text_w / 2), 20), text, HORIZONTAL_ALIGNMENT_CENTER, -1, 12)
        draw_line(Vector2(x, 20), Vector2(x, h), Color(0.2, 0.2, 0.2), 1)

func _gui_input(event):
    if event is InputEventMouseMotion:
        if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
            _update_time_point(event.position.x)
    if event is InputEventMouseButton and event.is_pressed():
        _update_time_point(event.position.x)


func time_to_x(_sec: float) -> int:
    return int(_sec * frame_rate * frame_per_px)


func _update_time_point(new_x: float):
    var snapped_x: float = round(new_x / frame_per_px) * frame_per_px
    snapped_x = clamp(snapped_x, 0, total_width)
    time_point.position.x = snapped_x

    var f := int(snapped_x / frame_per_px)
    var cur_time := float(f) / frame_rate
    frame_changed.emit(cur_time)
    time_point._set_frame_label(f)


func _add_animation_rect(_keyframe: Vector2, _title: String, _layer: int = 0):
    var animation_rect: AnimationRect = animation_rect_prefab.instantiate()
    animation_rect_parent.add_child(animation_rect)
    animation_rect.position.x = _keyframe.x * frame_per_px
    animation_rect.position.y = (_layer + 1) * 35
    animation_rect.initialize((_keyframe.y - _keyframe.x) * frame_per_px, _title)


func clear_animation_rect():
    for child in animation_rect_parent.get_children():
        child.queue_free()


var time := 0.0
func _update_animation_rect(_keyframes: Array[AnimationData]):
    clear_animation_rect()
    time = 0.0
    var track_ends := []

    for section : AnimationData in _keyframes:

        # Null Animation (Delay): Skip and don't draw
        if section.null_anim:
            time += section.duration
            continue

        var start = int(time * frame_rate)
        var end = int(start + section.duration * frame_rate)
        var placed = false
        var result_layer = 0

        # Check if the current section can be placed in an existing layer
        for i in range(track_ends.size()):
            if start >= track_ends[i]:
                track_ends[i] = end
                placed = true
                result_layer = i
                break

        # If not, add a new layer
        if not placed:
            track_ends.append(end)
            result_layer = track_ends.size() - 1

        _add_animation_rect(Vector2(start, end), section.key_path, result_layer)
        print(section.key_path, " " , start, " ", end)
        time += section.duration if section.wait else 0.0
