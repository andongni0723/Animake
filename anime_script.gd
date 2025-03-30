extends Node2D

var player;

func main() -> int:
	var ground = SquareCreate.make_square(Vector2(0, 0))
	ground.add_style("rounded-/10/ scale-/2/-/1/")
	ground.modulate = Color.GRAY

	Core.tween(ground, "position", Vector2(0, 300), 0.5)
	await Core.tween_and_wait(ground, "size", Vector2(6, 0.5), 0.5)

	player = SquareCreate.make_square(Vector2.ZERO)
	player.add_style("rounded-/10/ scale-/0/-/0/")

	player.add_style("pos-/-520/-/165/")
	await Core.tween_and_wait(player, "size", Vector2(0.5, 0.5), 0.3)

	var platform = SquareCreate.make_square(Vector2.ZERO)
	platform.add_style("pos-/100/-/0/ scale-/0/-/0/ rounded-/10/")
	platform.modulate = Color.GRAY

	await Core.tween_and_wait(platform, "size", Vector2(2, 0.5), 0.5)
	await _player_move_and_jump()

	return 0

func _player_move_and_jump():
	await Core.tween_and_wait(player, "pos_x", -350, 1)

	var jump_x = Core.new_tween(Tween.TRANS_LINEAR)
	jump_x.tween_property(player, "pos_x", 0, 1)

	var jump_y = Core.new_tween(Tween.TRANS_QUART)
	jump_y.tween_property(player, "pos_y", -250, 0.5).set_ease(Tween.EASE_OUT)
	jump_y.tween_property(player, "pos_y", -140, 0.5).set_ease(Tween.EASE_IN)
