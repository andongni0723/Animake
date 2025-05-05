extends Node
class_name Recorder

@export var viewport_path  : NodePath
@export var record_process : RecordAnimationProcess
@export var fps            : int    = 30
@export var duration_sec   : float  = 0.0
@export var output_dir     : String = "user://record"
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


func _setup_record_player():
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
    _rec_player.play(_anim_name, 0.0)
    _rec_player.stop()

func start_record():
    await _setup_record_player()
    print("Wait end")
    print(get_node_or_null("/root/Main Scene/Record Viewport/Anime Node Record/panel"))
    print(get_node_or_null("/root/Main Scene/Record Viewport/Anime Node Record/panel/Center/panel/text"))
    _rec_player.seek(0.0, true)
    _rec_player.play("RESET", 0.0)
    _rec_player.play(_anim_name, 0.0)
    print_animation_details()
    _frame = 0
    _frames_total = int(ceil(duration_sec * fps))
    _recording = true
    _prepare_dir()
    Engine.max_fps = fps
    get_tree().paused = false


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


func _process(_delta):
    if !_recording: return
    _capture_frame()
    _frame += 1
    if _frame >= _frames_total:
        _recording = false
        Engine.max_fps = 0
        call_deferred("_encode_video")

func _capture_frame():
    await get_tree().process_frame
    var img := _vp.get_texture().get_image()
    # img.flip_y()
    var path := "%s/frame_%05d.png" % [output_dir, _frame]
    img.save_png(path)

func _duplicate_anime_node() -> bool:
    var anime_node := GameManager.get_anime_node()
    if not anime_node or not _vp:
        HintManager.call_error_hint("Failed to get anime node")
        return false

    # ② 清舊副本
    var old := _vp.get_node_or_null("Anime Node Record")
    if old: old.queue_free()
    await get_tree().process_frame        # 等舊的真刪

    # ③ 複製並 deferred 加入，下一影格就會 ready
    var new_node := anime_node.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS)
    new_node.name = "Anime Node Record"
    await get_tree().process_frame
    _vp.add_child(new_node)
    _clone_anime_node = new_node

    # var ps := PackedScene.new()
    # ps.pack(anime_node)
    # var clone := ps.instantiate()
    # clone.name = "Anime Node Record"
    # _vp.add_child(clone)
    # _clone_anime_node = clone
    # print("Clone")

    await get_tree().create_timer(3.0).timeout
    return true


func _prepare_dir():
    DirAccess.make_dir_recursive_absolute(output_dir)

func _encode_video():
    print("start encoding")
    var out_name := "capture.webm" if use_alpha else "capture.mp4"
    var out_path := "%s/%s" % [output_dir, out_name]
    var pattern := output_dir + "/frame_%05d.png"

    var args := [
        "-y",
        "-r", str(fps),
        "-f", "image2",
        "-i", pattern,
    ]

    if use_alpha:
        args += [
            "-c:v", "libvpx-vp9",
            "-pix_fmt", "yuva420p",
            "-crf", "18",
            "-b:v", "0",
            out_path
        ]
    else:
        args += [
            "-c:v", "libx264",
            "-pix_fmt", "yuv420p",
            "-crf", "18",
            "-preset", "medium",
            out_path
        ]

    # 確保 ffmpeg_path 正確（若放在 res://ffmpeg/ffmpeg.exe）
    # if not FileAccess.file_exists(ffmpeg_path):
        # ffmpeg_path = ProjectSettings.globalize_path("res://ffmpeg/ffmpeg.exe")

    var output := []
    print(ffmpeg_path, " ", args)
    var code  := OS.execute("/usr/bin/env", ["ffmpeg"] + args, output)
    if code == OK:
        print("🎬  Video exported → ", out_path)
    else:
        push_error("FFmpeg failed, code %d" % code, "\n", "\n".join(output))
