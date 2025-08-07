extends Node

func _ready() -> void:
    main()
    
    
func main():
    var cube := Create.make_panel("cube", Vector2(-800, 0))
    var cube2 := Create.make_panel("cube2", Vector2(-800, -400))
    cube2.modulate = Color.RED
    var s := Flow.step()
    s.add(cube.tween.pos.x.from(-800).to(-100).span(0.3))
    s.add(cube2.tween.pos.y.from(cube2.pos.y).to(400).span(0.3))
    s.add(cube.tween.pos.x.to(800).span(0.3))
    s.end()
