# extends	Node2D

# var	player : Node2D;

# func _ready() -> void:
# 	main()
    
# func main():
# 	# Ground
# 	var	ground := Create.make_square("ground")
# 	print(ground.get_path())
# 	print(ground.get_path().get_concatenated_names().trim_prefix("root/"))
# 	ground.add_style("rounded-/10/ scale-/2/-/1/")
# 	ground.modulate	= Color.GRAY
# 	UIManager.timeline_panel.call_add_animation("Node2D/Anime Node/ground:position:y", Vector2(0, 1), 0, -200)
# 	# ground.tween_pos(Vector2(0, 300), 0.5)
# 	# await ground.fade_size(Vector2(6, 0.5), 0.5).wait()

# 	# Player Group
# 	var player_group: EmptyObject = Create.make_object("player_group")

# 	# Player 
# 	player = Create.make_square("player")
# 	player.add_style("rounded-/10/ scale-/0/-/0/")
# 	player.change_parent(player_group)
# 	player_group.add_style("pos-/-520/-/165/")
# 	player.fade_size(Vector2(0.5, 0.5), 0.3)


# 	# Player Text
# 	var player_text := Create.make_text("player_text", Vector2(0, -110))
# 	player_text.label.text = "Player"
# 	player_text.z_index = 1
# 	player_text.change_parent(player_group)

# 	# Platform
# 	var	platform := Create.make_square("platform")
# 	platform.add_style("pos-/100/-/0/ rounded-/10/ scale-/0/-/0/")
# 	platform.modulate =	Color.GRAY
# 	await platform.fade_size(Vector2(2, 0.5), 0.3).wait()

# 	# Player Jump
# 	await _player_move_and_jump(player_group)

# func _player_move_and_jump(_player: BaseObject):
# 	await _player.tween_pos_x(-350, 1).wait()
# 	_player.tween_pos_x(0, 1, Tween.TRANS_LINEAR)
# 	await _player.tween_pos_y(-250, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT).wait()
# 	await _player.tween_pos_y(-140, 0.5, Tween.TRANS_QUART, Tween.EASE_IN).wait()
