extends Node
class_name Recorder

@export var viewport_path  : NodePath
@export var record_process : RecordAnimationProcess
@export var fps            : int    = 30
@export var duration_sec   : float  = 0.0
@export var output_dir : String = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP) + "/AnimakeRecord"
@export var ffmpeg_path    : String = "ffmpeg"
@export var use_alpha      : bool   = false

var _frame := 0
var _frames_total := 0
var _recording := false
var _vp : Viewport

var _clone_anime_node : Node
var _rec_player : AnimationPlayer
var _anim_name : String

func _ready():
    _vp = get_node(viewport_path) as Viewport


func _setup_record_player() -> void:
    # Clone Anime Node
    if _recording: return
    await _duplicate_anime_node()

    # Create Animation Player for Recorder
    _rec_player = record_process.duplicate_animation_player_and_process_node_path()
    _rec_player.root_node = get_tree().root.get_path()
    add_child(_rec_player)
    print(_rec_player.root_node)

    # Initilize Args
    duration_sec = UIManager.timeline_panel.get_animation_duration()
    print(duration_sec)
    fps = UIManager.timeline_panel.timeline_canvas.frame_rate
    _anim_name = UIManager.timeline_panel.anim_name
    _rec_player.play("RESET", 0.0)
    _rec_player.play(_anim_name, 0.0)
    _rec_player.stop()

func start_record():
    HintManager.call_normal_hint("Start export video (.mp4)", 4)
    await _setup_record_player()
    print("Wait end")
    _rec_player.seek(0.0, true)
    _frame = 0
    _frames_total = int(ceil(duration_sec * fps))
    _prepare_dir()
    for i in range(_frames_total):
        _frame = i
        _rec_player.seek(float(_frame) / fps, true)
        await _capture_frame()
    await get_tree().process_frame
    call_deferred("_encode_video")    


func _capture_frame():
    await get_tree().process_frame
    var img := _vp.get_texture().get_image()
    var path := "%s/frame_%05d.png" % [output_dir, _frame]
    img.save_png(path)


func _duplicate_anime_node() -> bool:
    var anime_node := GameManager.get_anime_node()
    if not anime_node or not _vp:
        HintManager.call_error_hint("Failed to get anime node")
        return false

    # Clear old Anime Record
    var old := _vp.get_node_or_null("Anime Node Record")
    if old: old.queue_free()
    await get_tree().process_frame        # 等舊的真刪

    # Add new Anime Record and wait
    var new_node := anime_node.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS)
    new_node.name = "Anime Node Record"
    await get_tree().process_frame
    _vp.add_child(new_node)
    _clone_anime_node = new_node
    await get_tree().create_timer(3.0).timeout
    return true


func _prepare_dir():
    DirAccess.make_dir_recursive_absolute(output_dir)

func _encode_video():
    var ffmpeg := "/opt/homebrew/bin/ffmpeg"
    var out_name := "capture.webm" if use_alpha else "capture.mp4"
    var out_path := "%s/%s" % [output_dir, out_name]
    var pattern := output_dir + "/frame_%05d.png"

    var args := [
        "-y",
        "-framerate", str(fps),
        "-start_number", "1",
        "-i", pattern,
    ]

    if use_alpha:
        args += ["-c:v", "libvpx-vp9", "-pix_fmt", "yuva420p", "-crf", "18", "-b:v", "0", out_path]
    else:
        args += ["-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "18", "-preset", "medium", out_path]

    var output := []
    var code := OS.execute(ffmpeg, args, output, true)
    if code == OK:
        print("🎬  Video exported → ", out_path)
        HintManager.call_normal_hint("Video exported → " + out_path, 2)
    else:
        push_error("FFmpeg failed, code %d\n%s" % [code, "\n".join(output)])
        HintManager.call_error_hint("FFmpeg failed, code {}\n{}".format([code, "\n".join(output)], "{}"), 3)
        
        
#region Debug
func print_animation_details():
    print("\n=== ANIMATION DETAILS ===")

    for lib_name in _rec_player.get_animation_library_list():
        var lib := _rec_player.get_animation_library(lib_name)
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
