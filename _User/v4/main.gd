extends Node

func _ready() -> void:
    main()

func main():
    var ground = Create.make_panel("ground")
    ground.add_style("pos-/0/-/300/ size-/500/-/50/ radius-/10/ scale-/0/-/0/")

    var platform = Create.make_panel("platform")
    platform.add_style("pos-/100/-/600/ size-/100/-/50/ radius-/10/")

    var group = Create.make_object("group")

    var player = Create.make_panel("player")
    player.add_style("size-/50/-/50/ radius-/10/ scale-/0/-/0/")
    player.change_parent(group)

    var text = Create.make_text("text", Vector2(-20, -80))
    text.label.text = "Player"
    text.change_parent(group)
    # text.alpha = 0

    group.position = Vector2(-100, 240)

    var s = Flow.step()
    s.add(ground.tween.scale.to(Vector2.ONE).span(0.5))
    s.add(platform.tween.position.y.to(-300).span(0.4))
    s.add(platform.tween.position.y.to(-200).span(0.2))
    s.end()

    var a = Flow.all()
    a.add(player.tween.scale.to(Vector2.ONE).span(0.5))
    # a.add(text.tween.alpha.to(1).span(0.5))
    a.wait().end()

    a = Flow.all()
    a.add(group.tween.position.x.to(0).span(0.5).wait())
    a.add(group.tween.position.x.to(100).ease(1,1).span(1))
    a.end()

    var jump = Flow.step()
    jump.add(group.tween.position.y.to(-250).span(0.5))
    jump.add(group.tween.position.y.to(-200).span(0.5))
    jump.wait().end()
