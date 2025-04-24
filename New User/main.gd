extends Node 

func _ready():
  main()
  pass

func main():
  var panel := Create.make_square("panel")
  panel.add_style("rounded-/10/ scale-/0/-/0/ color-/GRAY/ z-/-1/")
  panel.self_modulate = Color.GRAY

  var button := Create.make_square("button")
  button.add_style("rounded-/10/ scale-/0.9/-/0.3/ alpha-/0/")
  button.size = Vector2(0.9, 0.3)
  button.color.a = 0
  button.change_parent(panel)

  var text := Create.make_text("button_text")
  text.label.text = "Button"
  text.modulate = Color.BLACK
  text.change_parent(button)

  var s = Flow.step()
  s.add(panel.tween.size.to(Vector2(1.2, 1.2)).span(0.4))
  s.add(panel.tween.size.to(Vector2(1, 1)).span(0.2))
  s.add(button.tween.color.a.to(1).span(0.5))
  s.add(button.tween.position.y.to(-100).span(0.2))
  s.add(button.tween.position.y.to(0).span(0.2))
#   s.add(Core.delay(0.5))
  s.end().wait()
