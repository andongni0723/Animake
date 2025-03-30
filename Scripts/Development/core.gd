extends Node

func spawn(prefab: PackedScene,	spawn_position:	Vector2	= Vector2.ZERO,	spawn_rotation:	float =	0) -> Node2D:
	var	instance := prefab.instantiate()
	instance.position =	spawn_position
	instance.rotation =	spawn_rotation
	GameManager._get_anime_node().add_child(instance)
	return instance
	
func new_tween(_trans: int = Tween.TRANS_QUART,	_ease: int = Tween.EASE_OUT) -> Tween:
	return get_tree().create_tween().set_trans(_trans).set_ease(_ease)

func timer(_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(_time)

func tween_and_wait(target:	Object,	property: String, final_value, duration: float,	trans: int = Tween.TRANS_QUART,	_ease: int = Tween.EASE_OUT) -> void:
	var	new_t :=	new_tween(trans)
	new_t.tween_property(target, property, final_value,	duration).set_ease(_ease)
	await new_t.finished

func tween(target:	Object,	property: String, final_value, duration: float,	trans: int = Tween.TRANS_QUART,	_ease: int = Tween.EASE_OUT) -> void:
	var	new_t =	new_tween(trans)
	new_t.tween_property(target, property, final_value,	duration).set_ease(_ease)
