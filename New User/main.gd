extends Node

func _ready() -> void:
	var obj = Create.make_square("object", Vector2(-200, 0))
	obj.add_style("rounded-/10/ scale-/0.5/-/0.5/")
	obj.tween_pos_x(200, 1)
	obj.tween_pos_x(-200, 1).wait()
	obj.tween_pos_x(400, 1)


# func f():
#     var object = Create.make_square("object", Vector2(-200, 0))
#     var seq = Flow.sequence()
#     seq.tween(obj.tween_pos_x(200, 1))
#     seq.tween(obj.tween_pos_x(-200, 1))
#     seq.end().wait()

#     var player = Create.make_square("player", Vector2(-200, 0))
#     player.add_style("rounded-/10/ scale-/0/-/0/")
#     var emp = Create.make_object("player_group")

#     player.change_parent(emp)
	
#     var all = Flow.all()
#     all.tween(emp.tween_pos_x(200, 1))
#     all.tween(emp.tween_pos_y(-200, 1))
#     all.end().wait()

#     delay(2).wait()

#     var lp = Flow.loop(3)
#     lp.tween(obj.tween_pos_x(200, 1))
