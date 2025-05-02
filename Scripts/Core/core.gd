extends Node

func add_anim_data(_data):
    UIManager.timeline_panel.add_animation_data(_data)
    pass

func delay(sec: float) -> TweenWrapper:
    return TweenWrapper.new(null, "", 0, 0, sec, 1, 1, true, true)


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
