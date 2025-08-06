extends Node

const RED: Color = Color(1.0, 0.392, 0.439, 1)
const GREEN: Color = Color(0.592, 0.761, 0.514, 1)
const BLUE: Color = Color(0.427, 0.671, 0.871, 1)
const YELLOW: Color = Color(0.996, 0.776, 0.435, 1)

var data := [1, 3, 4, 5, 6, 7, 10]
var target := 4
var cubes: Array[ImagePanel] = []
var title: Text = null
var l_bar: ImagePanel = null
var r_bar: ImagePanel = null
var mid: Text = null

func _ready(): 
    main()

func main():
    init()
    anim()

func init():
    # Title
    title = Create.make_text("Title", Vector2(-300, -500))
    title.add_style("size-/200/-/150/ font_size-/72/")
    title.label.text = "Binary Search"
    
    # Cubes
    for i in range(len(data)):
        var cube := Create.make_panel('cube' + str(i))
        var text := Create.make_text(str(i))
        cube.add_style("size-/150/-/150/ radius-/10/")
        cube.z_index = 5
        cube.pos_x = -600 + 200 * i
        text.add_style("size-/150/-/150/ text-/{}/ font_size-/72/".format([data[i]], "{}"))
        text.modulate = Color.BLACK
        text.change_parent(cube.center)
        cubes.append(cube)
        
    var _target := Create.make_text("Target", Vector2(300, -500))
    _target.add_style("size-/200/-/150/ font_size-/48/")
    _target.label.text = "Target: {}".format([target], '{}')
    
    l_bar = Create.make_panel("L Bar")
    l_bar.add_style("pos-/-800/-/-50/ radius-/10/ size-/150/-/350/")
    l_bar.color = RED
    l_bar.z_index = 3
    
    var _l_bar_text := Create.make_text('text')
    _l_bar_text.add_style("size-/100/-/100/ text-/L/ font_size-/72/")
    _l_bar_text.change_parent(l_bar.center)
    _l_bar_text.modulate = Color.WHITE

    r_bar = Create.make_panel("R Bar")
    r_bar.add_style("pos-/800/-/-50/ radius-/10/ size-/150/-/350/")
    r_bar.color = BLUE
    r_bar.z_index = 3

    var _r_bar_text := Create.make_text('text')
    _r_bar_text.add_style("size-/100/-/100/ text-/R/ font_size-/72/")
    _r_bar_text.change_parent(r_bar.center)
    _r_bar_text.modulate = Color.WHITE
    
    mid = Create.make_text('mid')
    mid.add_style("pos-/0/-/200/ text-/mid/ font_size-/72/ alpha-/0/")
    mid.modulate = YELLOW
    

func anim():
    var s := Flow.step()
    mid.pos.x = cubes[3].pos_x - 20 
    s.add(l_bar.tween.size.y.to(350).span(0))
    s.add(r_bar.tween.size.y.to(350).span(0))
    s.add(mid.tween.alpha.from(0.0).to(1.0).span(0.3))
    s.add(Core.delay(0.5))
    s.wait().end()
    
    var a := Flow.all()
    a.add(r_bar.tween.pos.x.from(800).to((800 - cubes[3].pos.x - 150 - 50) / 2).span(0.5))
    a.add(r_bar.tween.size.x.from(100).to(800).span(0.5))
    a.wait().end()

    s = Flow.step()
    s.add(Core.delay(0.5))
    s.add(mid.tween.pos.x.to(cubes[1].pos_x - 20).span(0.3))
    s.add(Core.delay(0.5))
    s.wait().end()

    a = Flow.all()
    a.add(l_bar.tween.pos.x.from(-800).to((-800 + cubes[1].pos.x + 150 + 50) / 2).span(0.5))
    a.add(l_bar.tween.size.x.from(100).to(400).span(0.5))
    a.wait().end()

    s = Flow.step()
    s.add(Core.delay(0.5))
    s.add(mid.tween.pos.x.from(cubes[1].pos_x - 20).to(cubes[2].pos_x - 20).span(0.3))
    s.add(Core.delay(0.5))
    s.wait().end()
    
    a = Flow.all()
    a.add(mid.tween.label.text.to('target').span(0.3))
    a.add(mid.tween.modulate.to(GREEN).span(0.3))
    a.wait().end()
    
    Flow.step().add(Core.delay(1)).wait().end()
