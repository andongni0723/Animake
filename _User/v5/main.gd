extends Node

const RED: Color = Color(1.0, 0.392, 0.439, 1)
const GREEN: Color = Color(0.592, 0.761, 0.514, 1)
const BLUE: Color = Color(0.427, 0.671, 0.871, 1)
const YELLOW: Color = Color(0.996, 0.776, 0.435, 1)

func _ready():
    main()


func main():
    var panel := Create.make_panel("panel")
    panel.add_style("size-/1000/-/500/ radius-/50/")
    panel.self_color = RED

    var text := Create.make_text("text")
    text.change_parent(panel.panel)
    text.label.text = "START"
    text.label.modulate = Color.BLACK
    text.size = panel.size
    text.font_size = 128
    # text.label.set_variation_axis("wght", 800)


    var a = Flow.all()
    a.add(panel.tween.size.to(Vector2(1200, 500)).span(0.8))
    a.add(panel.tween.self_color.to(GREEN).span(0.8))
    a.add(text.tween.label.text.to("CONTENT").span(0.5))
    a.add(text.tween.size.to(Vector2(1200, 500)).span(0.8))
    a.wait().end()

    a = Flow.all()
    a.add(panel.tween.size.x.from(1200).to(1500).span(0.8))
    a.add(panel.tween.self_color.from(GREEN).to(BLUE).span(0.8))
    a.add(panel.tween.rotation_degrees.to(-5.0).span(0.8))
    a.add(text.tween.label.text.from("CONTENT").to("ANIMATION").span(0.5))
    a.add(text.tween.size.x.from(1200).to(1500).span(0.8))
    a.wait().end()

    a = Flow.all()
    a.add(panel.tween.size.x.from(1500).to(1000).span(0.8))
    a.add(panel.tween.self_color.from(BLUE).to(YELLOW).span(0.8))
    a.add(panel.tween.rotation_degrees.from(-5.0).to(0.0).span(0.8))
    a.add(text.tween.label.text.from("ANIMATION").to("END").span(0.5))
    a.add(text.tween.size.x.from(1500).to(1000).span(0.8))
    a.wait().end()
