extends Node

func _ready() -> void:
    main()

func main():
    var ground = Create.make_panel("ground")
    ground.add_style("pos-/0/-/300/ size-/800/-/50/ radius-/10/ scale-/0/-/0/")

    var platform = Create.make_panel("platform")
    platform.add_style("pos-/250/-/600/ size-/250/-/50/ radius-/10/")

    var group = Create.make_object("group")

    var player = Create.make_panel("player")
    player.add_style("size-/50/-/50/ radius-/10/ scale-/0/-/0/")
    player.change_parent(group)

    var text = Create.make_text("text", Vector2(-20, -80))
    text.label.text = "Player"
    text.change_parent(group)
    # text.alpha = 0

    group.position = Vector2(-100, 245)

    var s = Flow.step()
    s.add(ground.tween.scale.from(Vector2.ZERO).to(Vector2.ONE).span(0.5))
    s.add(platform.tween.position.y.to(0).span(0.4))
    s.add(platform.tween.position.y.from(0).to(50).span(0.2))
    s.end()

    var a = Flow.all()
    a.add(player.tween.scale.from(Vector2.ZERO).to(Vector2.ONE).span(0.5))
    # a.add(text.tween.alpha.to(1).span(0.5))
    a.wait().end()

    a = Flow.all()
    a.add(group.tween.position.x.to(0).span(0.5).wait())
    a.add(group.tween.position.x.from(0).to(250).ease(1,1).span(1))
    a.end()

    var jump = Flow.step()
    jump.add(group.tween.position.y.to(-300).ease(2, 0.2).span(0.5))
    jump.add(group.tween.position.y.from(-50).to(-5).ease(2, 4).span(0.5))
    jump.wait().end()
