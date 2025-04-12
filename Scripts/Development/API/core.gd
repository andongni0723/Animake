extends	Node

func spawn(prefab: PackedScene,	_name: String, spawn_position: Vector2 =	Vector2.ZERO, spawn_rotation: float = 0) -> Node2D:
	var	instance := prefab.instantiate()
	instance.name =	_name
	instance.position =	spawn_position
	instance.rotation =	spawn_rotation
	GameManager._get_anime_node().add_child(instance)
	ToolSignal.emit_signal("anime_object_add_group_done")
	return instance
	
func new_tween(_trans: int = Tween.TRANS_QUART,	_ease: int = Tween.EASE_OUT) -> Tween:
	return get_tree().create_tween().set_trans(_trans).set_ease(_ease)

func timer(_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(_time)

func tween(target: Object, property: String, final_value, duration:	float,	_trans:	int	= Tween.TRANS_QUART,	_ease: int = Tween.EASE_OUT) -> TweenWrapper:
	var	t := new_tween(_trans, _ease)
	t.tween_property(target, property, final_value,	duration)
	var	wrapper	:= TweenWrapper.new()
	wrapper.tween =	t
	return wrapper
