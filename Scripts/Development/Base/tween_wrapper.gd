# TweenWrapper.gd
extends RefCounted
class_name TweenWrapper

var tween: Tween

func wait() -> Variant:
	return tween.finished
