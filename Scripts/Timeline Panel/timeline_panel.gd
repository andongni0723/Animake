extends	Control

@export var animation_player: AnimationPlayer
@export var slider: HSlider
@export var timeline_canvas: TimelineCanvas
var	anim_name := "timeline_anim"

func _enter_tree() -> void:
	timeline_canvas.frame_changed.connect(_on_frame_changed)

func _ready():
	var node = Create.make_square("square")
	node.change_parent(self)
	node.pos_y = -200

	# 1. 設定動畫
	var library = AnimationLibrary.new()
	var anim = Animation.new()
	anim.length = 2.0
	var track_id = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_id, "square:position:x")
	anim.track_insert_key(track_id, 0.0, 0.0)
	anim.track_insert_key(track_id, 2.0, 100)
	library.add_animation(anim_name, anim)
	animation_player.add_animation_library(anim_name, library)
	animation_player.play("timeline_anim/timeline_anim", 0.0)

	# 2. 設定滑桿
	slider.min_value = 0
	slider.max_value = anim.length
	slider.step	= 1.0 /	60.0
	slider.value = 0

	slider.value_changed.connect(_on_slider_value_changed)

func _on_slider_value_changed(time_sec):
	# 每次拖動滑桿就跳到對應時間
	animation_player.seek(time_sec,	true)

func _on_play_button_pressed():
	animation_player.play(anim_name, slider.value)

func _on_pause_button_pressed():
	animation_player.playback_active = false

func _on_frame_changed(new_time: float):
	animation_player.seek(new_time, true)
