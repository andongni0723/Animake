# TweenWrapper.gd
extends RefCounted
class_name TweenWrapper

var tween: Tween

func wait() -> Variant:
	# 回傳 tween.finished 這個 awaitable 狀態
	return tween.finished
