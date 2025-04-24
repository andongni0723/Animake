extends Node

func _ready():
	main()
	pass

var panel: Square
var button: Square

func _process(_delta: float) -> void:
	pass
	# if panel and button:
		# button.size.x = panel.size.x

func main():
	panel = Create.make_square("panel")
	panel.add_style("rounded-/10/ scale-/0/-/0/")
	panel.color = Color.GRAY
	panel.z_index = -1

	button = Create.make_square("button")
	button.add_style("rounded-/10/ scale-/0/-/0/")
	button.change_parent(panel)
	button.size = Vector2(0.9, 0.3)
	button.color = Color.WHITE
	button.color.a = 1

	var text = Create.make_text("button_text")
	text.change_parent(button)
	text.label.text = "Button"
	text.modulate = Color.BLACK


	await panel.fade_size(Vector2(1.2, 1.2), 0.4).wait()
	await panel.fade_size(Vector2(1, 1), 0.2).wait()
	await button.fade_alpha(1, 0.5).wait()
	await button.tween_pos_y(-10, 0.2).wait()
	await button.tween_pos_y(0, 0.2).wait()

	# var s = Flow.step()
	# s.add(panel.size.to(Vector2(1.2, 1.2)).span(0.4))
	# s.add(panel.size.to(Vector2(1, 1)).span(0.2))
	# s.add(button.color.a.to(1).span(0.5))
	# s.add(button.position.y.to(-10).span(0.2))
	# s.add(button.position.y.to(0).span(0.2))
	# s.add(Core.delay(0.5))
	# s.end().wait()
