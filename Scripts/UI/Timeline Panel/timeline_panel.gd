class_name TimelinePanel extends Control

@export var animation_player: AnimationPlayer
@export var timeline_canvas: TimelineCanvas
@export var play_button: Button
@export var stop_button: Button

var _animation_data_array: Array[AnimationData]

var anim_name := "timeline_anim"
var _library: AnimationLibrary
var _anim: Animation = Animation.new()
var _reset_anim: Animation = Animation.new()
var anim_duration := 0.0

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
    animation_player.play(anim_name, 0.0)
    animation_player.stop()
    print("Libraries:", animation_player.get_animation_library_list())
    print("Animations:", animation_player.get_animation_list())

func _process(_delta: float) -> void:
    if animation_player.current_animation:
        var x = timeline_canvas.time_to_x(animation_player.current_animation_position)
        timeline_canvas._update_time_point(x)


func _animation_initialize():
    # Add main animation
    if _library.has_animation(anim_name):
        _library.remove_animation(anim_name)
    _library.add_animation(anim_name, _anim)

    # Add RESET animation
    if _library.has_animation("RESET"):
        _library.remove_animation("RESET")
    _reset_anim.length = 0.0
    _library.add_animation("RESET", _reset_anim)


func _clear_array_and_initialize(_p):
    # Data clear
    _animation_data_array.clear()
    timeline_canvas.clear_animation_rect()
    anim_duration = 0.0

    # Animation Delete and Initialize
    _anim = Animation.new()
    _reset_anim = Animation.new()
    # animation_player.stop()
    _animation_initialize()


func add_animation_data(_data: AnimationData):
    # Null path: add animation empty space
    if str(_data.key_path) != "" or not _data.null_anim:
        call_add_animation(_data.key_path, Vector2(anim_duration, anim_duration + _data.duration), _data.from, _data.to, _data.ease_)

    anim_duration += _data.duration if _data.wait else 0.0
    _anim.length = anim_duration
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


func get_animation_duration() -> float:
    return anim_duration


func stop_animation():
    timeline_canvas._update_time_point(0)
    animation_player.stop()


func play_animation():
    animation_player.seek(0.0, true)
    animation_player.play("RESET", 0.0)
    animation_player.play(anim_name, 0.0)
#    print_animation_details()


func _on_frame_changed(new_time: float):
    if animation_player.is_playing(): return

    animation_player.seek(new_time, true)

#region Debug
func _print_animation_data_array():
    for i in _animation_data_array:
        print("AnimationData:", i.key_path, " ", i.duration, " ", i.from, " ", i.to," ", i.wait)

func print_animation_details():
    print("\n=== ANIMATION DETAILS ===")

    for lib_name in animation_player.get_animation_library_list():
        var lib := animation_player.get_animation_library(lib_name)
        print("\nLibrary: ", str(lib_name) if not lib_name.is_empty() else "(default)")

        for anim_name_ in lib.get_animation_list():
            var anim := lib.get_animation(anim_name_)
            print("  Animation: %-16s | Length: %.2f  | Tracks: %d"
                  % [anim_name_, anim.length, anim.get_track_count()])

            for t in range(anim.get_track_count()):
                var key_cnt := anim.track_get_key_count(t)

                print("\n    Track %02d (%s): %s  | Keys: %d"
                      % [t, anim.track_get_type(t),
                         anim.track_get_path(t), key_cnt])

                for k in range(key_cnt):
                    var _time := anim.track_get_key_time(t, k)
                    var value = anim.track_get_key_value(t, k)
                    var trans := anim.track_get_key_transition(t, k)
                    print("      Key %-2d: anim_duration=%.3f  value=%s  transition=%.2f" % [k, _time, value, trans])

#endregion
