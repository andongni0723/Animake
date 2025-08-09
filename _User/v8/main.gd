extends Node

const RED: Color = Color(1.0, 0.392, 0.439, 1)
const GREEN: Color = Color(0.592, 0.761, 0.514, 1)
const BLUE: Color = Color(0.427, 0.671, 0.871, 1)
const YELLOW: Color = Color(0.996, 0.776, 0.435, 1)

# ------

var data: Array[int] = [1, 7, 3, 5, 12, 10]
# action: add(i: int, v: int)
# action: sum(l: int, r: int)
var actions: Array[Array] = [["add", 2, 5], ["add", 0, 1], ["sum", 0, 5], ["sum", 2, 4]]

var bit_data: Array[int]
var group: Array[ImagePanel]
var num_group: Array[Text]
var group_node: BaseObject
var bit_group: Array[ImagePanel]
var bit_num_group: Array[Text]
var bit_group_node: BaseObject
var bit_build_actions: Array[Vector2i] # index, new_val
var action_text: Text

var time_text: Text
var bit_time_text: Text

var s := Flow.step()
var a := Flow.all()

func _ready() -> void:
    main()


func main():
    init()
    anim()

func init():
    bit_data = build_bit(data)
    var _zero := []
    _zero.resize(len(data) + 1)
    _zero.fill(0)
    
    group_node = Create.make_object("data_group_node")
    bit_group_node = Create.make_object("bit_data_group_node")
    
    var _title := Create.make_text('title', Vector2(-700, -550))
    _title.add_style("font_size-/72/ weight-/800/")
    _title.label.text = "Binary Index Tree"
    
    action_text = Create.make_text('action_text', Vector2(-750, 300))
    action_text.add_style("font_size-/72/ text-/build()/ weight-/700/ ")
    action_text.modulate = BLUE
    
    time_text = Create.make_text('time_text', Vector2(-300, 300))
    var _sep = Create.make_text('sep', Vector2(-150, 300))
    _sep.add_style("font_size-/72/ weight-/800/ alpha-/0.7/")
    _sep.label.text = '/'
    bit_time_text = Create.make_text('bit_time_text', Vector2(100, 300))
    time_text.add_style("font_size-/72/ text-/O(n)/ weight-/800/")
    bit_time_text.add_style("font_size-/72/ text-/O(n)/ weight-/800/ size-/150/-/0/")
    bit_time_text.modulate = GREEN

    var _data_title := Create.make_text('_data_title', Vector2(-1000, -300))
    _data_title.add_style("font_size-/48/ text-/Data/ weight-/500/")

    var _bit_title := Create.make_text('_bit_title', Vector2(-1000, 0))
    _bit_title.add_style("font_size-/48/ text-/BIT/ weight-/500/")
    _bit_title.modulate = GREEN
    
    group     = build_array_node(data, group_node, num_group, -300)
    bit_group = build_array_node(bit_data, bit_group_node, bit_num_group, 0)
    

func build_bit(arr) -> Array[int]:
    var n := len(arr)
    var bit: Array[int] = []
    bit.resize(n+1)
    bit.fill(0)
    for i in range(1, n+1):
        bit[i] += arr[i-1]
        bit_build_actions.append(Vector2i(i, bit[i]))
        var j = i + (i & -i)
        if j <= n:
            bit[j] += bit[i]
            bit_build_actions.append(Vector2i(j, bit[j]))
    return bit
    
    
func build_array_node(arr, parent, text_group: Array, pos_y) -> Array[ImagePanel]:
    var res: Array[ImagePanel] = []
    for i in range(len(arr)):
        var _cube := Create.make_panel("data-%d" % i, Vector2(0, pos_y))
        var _text := Create.make_text("text")
        _cube.add_style("size-/150/-/150/ radius-/10/")
        _cube.pos.x = -800 + i * 200
        _text.add_style("size-/150/-/150/ text-/%d/ font_size-/72/ weight-/600/" % arr[i])
        _text.change_parent(_cube.center)
        _text.modulate = Color.BLACK
        _cube.change_parent(parent)
        res.append(_cube)
        if text_group == null: continue
        text_group.append(_text)
    return res

func anim():
    
    s = Flow.step()
    s.add(action_text.tween.alpha.from(0.0).to(1.0).span(0.5))
    s.add(time_text.tween.alpha.from(0.0).to(1.0).span(0.5))
    s.add(bit_time_text.tween.alpha.from(0.0).to(1.0).span(0.5))
    s.wait().end()
    
#    for action in bit_build_actions:
#        var _idx     := action.x
#        var _new_val := action.y
#        _change_text_and_color(bit_group[_idx], bit_num_group[_idx], _new_val, GREEN)
        
    for action in actions:

        s = Flow.step()
        s.add(time_text.tween.alpha.to(0.0).span(0.5))
        s.add(bit_time_text.tween.alpha.to(0.0).span(0.5))
        s.wait().end()
        
        match action[0]: # action name
            "add":
                _add(action[1], action[2])
            "sum":
                _sum(action[1], action[2])
        
        Flow.step().add(Core.delay(1)).wait().end()
            
            
func _change_text_and_color(panel: ImagePanel, text: Text, value: int, color: Color = GREEN):
    a = Flow.all()
    a.add(text.tween.label.text.to(str(value)).span(0.5))
    a.add(panel.tween.modulate.to(color).span(0.3)).wait()
    a.add(Core.delay(0.5)).wait()
    a.add(panel.tween.modulate.to(Color.WHITE).span(0.3))
    a.wait().end()
    
func _change_color(panel: ImagePanel, color: Color):
    a = Flow.all()
    a.add(panel.tween.modulate.to(color).span(0.3)).wait()
    a.add(Core.delay(0.5)).wait()
    a.add(panel.tween.modulate.to(Color.WHITE).span(0.3))
    a.wait().end()
    
func _change_action_text(new_text: String, dur: float = 0.3):
    s = Flow.step()
    s.add(action_text.tween.label.text.to(new_text).span(dur))
    s.add(Core.delay(1))
    s.wait().end()
    
    
func _add(i: int, v: int):
    i += 1
    _change_action_text("add(%d, %d)" % [i, v])
    _change_text_and_color(group[i], num_group[i], v, YELLOW)
    
    a = Flow.all()
    a.add(time_text.tween.alpha.to(1.0).span(0.5))
    a.add(time_text.tween.label.text.to("O(1)").span(0.5)).wait()
    a.add(Core.delay(0.5))
    a.wait().end()
    
    while i < len(bit_data):
        print(i)
        bit_data[i] += v
        _change_text_and_color(bit_group[i], bit_num_group[i], bit_data[i])
        i += (i & -i)
        
    a = Flow.all()
    a.add(bit_time_text.tween.alpha.to(1.0).span(0.5))
    a.add(bit_time_text.tween.label.text.to("O(log n)").span(0.5)).wait()
    a.add(Core.delay(0.5))
    a.wait().end()
    
    
func _sum(l: int, r: int):
    _change_action_text("sum(%d, %d)" % [l, r])
