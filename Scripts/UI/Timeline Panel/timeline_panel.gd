class_name TimelinePanel extends Control

@export var animation_player: AnimationPlayer
@export var timeline_canvas: TimelineCanvas
@export var play_button: Button
@export var stop_button: Button

var _animation_data_array: Array[AnimationData]

var _anim_name := "timeline_anim"
var _library: AnimationLibrary
var _anim: Animation = Animation.new()
var _reset_anim: Animation = Animation.new()

func _enter_tree() -> void:
    ToolSignal.select_folder.connect(_clear_array_and_initialize)
    timeline_canvas.frame_changed.connect(_on_frame_changed)
    play_button.pressed.connect(play_animation)
    stop_button.pressed.connect(stop_animation)
    animation_player.root_node = get_tree().root.get_path()

func _exit_tree() -> void:
    ToolSignal.select_folder.disconnect(_clear_array_and_initialize)

func _ready():
    if animation_player.has_animation_library(""):
        _library = animation_player.get_animation_library("")
    else:
        _library = AnimationLibrary.new()
        animation_player.add_animation_library("", _library)

    _animation_initialize()
    animation_player.play(_anim_name, 0.0)
    animation_player.stop()
    print("Libraries:", animation_player.get_animation_library_list())
    print("Animations:", animation_player.get_animation_list())

func _process(_delta: float) -> void:
    if animation_player.current_animation:
        var x = timeline_canvas.time_to_x(animation_player.current_animation_position)
        timeline_canvas._update_time_point(x)


func _animation_initialize():
    # Add main animation
    if _library.has_animation(_anim_name):
        _library.remove_animation(_anim_name)
    _library.add_animation(_anim_name, _anim)

    # Add RESET animation
    if _library.has_animation("RESET"):
        _library.remove_animation("RESET")
    _reset_anim.length = 0.0
    _library.add_animation("RESET", _reset_anim)


func _clear_array_and_initialize(_p):
    # Data clear
    _animation_data_array.clear()
    timeline_canvas.clear_animation_rect()
    time = 0.0

    # Animation Delete and Initialize
    _anim = Animation.new()
    _reset_anim = Animation.new()
    # animation_player.stop()
    _animation_initialize()


var time := 0.0
func add_animation_data(_data: AnimationData):
    # Null path: add animation empty space
    if str(_data.key_path) != "" or not _data.null_anim:
        call_add_animation(_data.key_path, Vector2(time, time + _data.duration), _data.from, _data.to, _data.ease_)

    time += _data.duration if _data.wait else 0.0
    _anim.length = time
    _animation_data_array.append(_data)
    timeline_canvas._update_animation_rect(_animation_data_array)


func call_add_animation(_path: String, _time: Vector2, _start_value, _end_value, _trans: float):
    var track_id := _anim.find_track(_path, Animation.TYPE_VALUE)
    if track_id == -1:
        track_id = _anim.add_track(Animation.TYPE_VALUE)
        _anim.track_set_path(track_id, _path)

    _anim.track_insert_key(track_id, _time.x, _start_value, _trans)

    # Setting Transition
    var start_key_idx := _anim.track_find_key(track_id, _time.x)
    if start_key_idx != -1:
        _anim.track_set_key_transition(track_id, start_key_idx, _trans)

    _anim.track_insert_key(track_id, _time.y, _end_value, _trans)

    # Add to RESET animation
    var reset_tid := _reset_anim.find_track(_path, Animation.TYPE_VALUE)
    if reset_tid == -1:
        reset_tid = _reset_anim.add_track(Animation.TYPE_VALUE)
        _reset_anim.track_set_path(reset_tid, _path)
        _reset_anim.track_insert_key(reset_tid, 0.0, _start_value)


func stop_animation():
    timeline_canvas._update_time_point(0)
    animation_player.stop()


func play_animation():
    animation_player.seek(0.0, true)
    animation_player.play("RESET", 0.0)
    animation_player.play(_anim_name, 0.0)
    print_animation_details()


func _on_frame_changed(new_time: float):
    if animation_player.is_playing(): return

    animation_player.seek(new_time, true)

#region Debug
func _print_animation_data_array():
    for i in _animation_data_array:
        print("AnimationData:", i.key_path, " ", i.duration, " ", i.from, " ", i.to," ", i.wait)

func print_animation_details():
    print("\n=== ANIMATION DETAILS ===")

    # 打印所有动画库
    var libraries = animation_player.get_animation_library_list()
    print("Libraries: ", libraries)

    # 遍历每个库
    for lib_name in libraries:
        var library = animation_player.get_animation_library(lib_name)
        if lib_name != "":
            print("\nLibrary: ", lib_name)
        else:
            print("\nLibrary: (default)")

        # 打印库中的所有动画
        var animations = library.get_animation_list()
        print("  Animations: ", animations)

        # 详细打印每个动画
        for anim_name in animations:
            var animation = library.get_animation(anim_name)
            print("\n  Animation: ", anim_name)
            print("    Length: ", animation.length, " seconds")
            print("    Track count: ", animation.get_track_count())

            # 打印每个轨道的信息
            for track_idx in range(animation.get_track_count()):
                var track_type = animation.track_get_type(track_idx)
                var track_path = animation.track_get_path(track_idx)

                # 获取轨道类型名称
                var type_name = "Unknown"
                match track_type:
                    Animation.TYPE_VALUE: type_name = "Value"
                    Animation.TYPE_POSITION_3D: type_name = "Position3D"
                    Animation.TYPE_ROTATION_3D: type_name = "Rotation3D"
                    Animation.TYPE_SCALE_3D: type_name = "Scale3D"
                    Animation.TYPE_BLEND_SHAPE: type_name = "BlendShape"
                    Animation.TYPE_METHOD: type_name = "Method"
                    Animation.TYPE_BEZIER: type_name = "Bezier"
                    Animation.TYPE_AUDIO: type_name = "Audio"
                    Animation.TYPE_ANIMATION: type_name = "Animation"

                print("    Track ", track_idx, " (", type_name, "): ", track_path)

                # 打印轨道上的关键帧
                var key_count = animation.track_get_key_count(track_idx)
                print("      Key count: ", key_count)

                for key_idx in range(key_count):
                    var key_time = animation.track_get_key_time(track_idx, key_idx)
                    var key_value = animation.track_get_key_value(track_idx, key_idx)
                    var transition = animation.track_get_key_transition(track_idx, key_idx)
                    print("      Key ", key_idx, ": time=", key_time, ", value=", key_value, ", transition=", transition)
#endregion
