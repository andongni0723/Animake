extends Node 

func _ready():
  main()
  pass

func main():
  var panel := Create.make_panel("panel")
  panel.add_style("rounded-/10/ scale-/0/-/0/ color-/GRAY/ z-/-1/")
  panel.size = Vector2(250, 300)
  panel.scale = Vector2(0, 0)
  panel.self_color = Color.GRAY

#   var group : = Create.make_object("group")
#   group.change_parent(panel)

#   var button := Create.make_square("button")
  var button: ImagePanel = Create.make_panel("button")
  button.add_style("rounded-/10/ scale-/0.9/-/0.3/ alpha-/0/")
#   button.scale = Vector2(0.9, 0.3)
  button.size = Vector2(200, 50)
  button.alpha = 0.0
  button.change_parent(panel.panel)

  var text := Create.make_text("button_text")
  text.label.text = "Button"
  text.modulate = Color.BLACK
  text.size = button.size
  text.change_parent(button.panel)

  ToolSignal.anime_object_add_group_done.emit()

  var s = Flow.step()
  s.add(panel.tween.scale.to(Vector2(0.0, 0.0)).span(0.01))
  s.add(panel.tween.scale.to(Vector2(1.2, 1.2)).span(0.4))
  s.add(panel.tween.scale.to(Vector2(1, 1)).span(0.2))
  s.add(button.tween.alpha.to(1.0).span(0.5))
  s.add(button.tween.position.y.to(-100).span(0.2))
  s.add(button.tween.position.y.to(0).span(0.2))
  s.end().wait()
