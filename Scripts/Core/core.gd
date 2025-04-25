extends Node

func add_anim_data(_data):
    UIManager.timeline_panel.add_animation_data(_data)
    pass

# func delay(sec: float) -> TweenWrapper:
    # return TweenWrapper.new(Node2D.new(), "", 0, 0, sec, Animation.INTERPOLATION_LINEAR, -1).wait()

func spawn(prefab: PackedScene, _name: String, spawn_position: Vector2 = Vector2.ZERO, spawn_rotation: float = 0) -> Node2D:
    var instance := prefab.instantiate()
    instance.name = _name
    instance.position = spawn_position
    instance.rotation = spawn_rotation
    GameManager._get_anime_node().add_child(instance)
    ToolSignal.emit_signal("anime_object_add_group_done")
    return instance
    
func new_tween(_trans: int = Tween.TRANS_QUART, _ease: int = Tween.EASE_OUT) -> Tween:
    ToolSignal.anime_object_add_group_done.emit()
    return get_tree().create_tween().set_trans(_trans).set_ease(_ease)

func timer(_time: float) -> SceneTreeTimer:
    return get_tree().create_timer(_time)

# func tween(target: Object, property: String, final_value, duration: float, _trans: int = Tween.TRANS_QUART,    _ease: int = Tween.EASE_OUT) -> TweenWrapper:
#     if not target: return null
#     var t := new_tween(_trans, _ease)
#     t.tween_property(target, property, final_value, duration)
#     var wrapper := TweenWrapper.new()
#     wrapper.tween = t
#     return wrapper

# func n_tween(target: BaseObject, property: String, start_value, final_value, duration: float, interpolation: Animation.InterpolationType = Animation.INTERPOLATION_LINEAR, _ease: float = 1) -> AnimationData:
#   if not target: return null
#   var _path := target.get_path().get_concatenated_names().trim_prefix("root/")
#   var data: AnimationData = AnimationData.new(_path + ':' + property, duration, start_value, final_value, interpolation, _ease)
#   UIManager.timeline_panel.add_animation_data(data)
#   return data
