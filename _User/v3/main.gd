extends Node

func _ready():
    main2()
    pass

func main():
    var panel: ImagePanel = Create.make_panel("panel")
    panel.add_style("rounded-/10/ scale-/0/-/0/ color-/GRAY/ z-/-1/")
    panel.size = Vector2(250, 300)
    panel.scale = Vector2(0, 0)
    panel.self_color = Color.GRAY

    var button: ImagePanel = Create.make_panel("button")
    button.add_style("rounded-/10/ scale-/0.9/-/0.3/ alpha-/0/")
    button.size = Vector2(200, 10)
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

func main2():
    var rects: Array[ImagePanel] = []

    for i in range(5):
        var x = i * 70
        rects.append(Create.make_panel("rect", Vector2(-300 + x, -300)))
        rects[i].add_style("radius-/10/ size-/50/-/50/")
        # rects[i].radius = 10
        # rects[i].size = Vector2(50, 50)

    var a = Flow.all()
    for i in rects:
        a.add(i.tween.position.y.to(300).span(0.5))
    a.wait().end()

    var b = Flow.all()
    for i in rects:
        b.add(i.tween.position.y.to(-300).span(0.5))
    b.wait().end()
