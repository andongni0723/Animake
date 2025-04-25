extends Node2D
class_name BaseObject

var tween: TweenProxy

var pos_x: float = 0.0:
    set(value):
        pos_x = value
        position.x = value
    get:
        pos_x = position.x
        return pos_x

var pos_y: float = 0.0:
    set(value):
        pos_y = value
        position.y = value
    get:
        pos_y = position.y
        return pos_y
    
var base_object_data: SettingDetail = preload("res://Data/Object Property Data/base_object_data.tres")

func _init() -> void:
    tween = TweenProxy.new(self)
    pass

func get_base_data() -> Array[SettingProperty]:
    return base_object_data.properties.duplicate()

## Override by child class 
## 
## @experimental 
## [codeblock]
## var data_name: SettingDetail =  Datpreload("res://Data/Object Property Data/text_data.tres")
## 
## func get_data() -> Array[SettingProperty]:
##     var result = super.get_data()
##     result.append_array(data_name.properties.duplicate())
##     return result
## [/codeblock]
func get_data() -> Array[SettingProperty]:
    return base_object_data.properties.duplicate()

func change_parent(new_parent: Node) -> void:
    if get_parent():
        get_parent().remove_child(self)
    new_parent.add_child(self)

func add_style(style_string: String) -> void:
    var styles = style_string.split(' ')
    for style in styles:
        if style.begins_with("pos"):
            position = NodeStyleInterpreter.position_interpret(style)


# func tween_pos_x(final_value, duration: float,  trans: int = Tween.TRANS_QUART, _ease: int = Tween.EASE_OUT) -> AnimationData:
#     # return Core.tween(self,   "pos_x", final_value, duration, trans, _ease)
#     return Core.n_tween(self, "position:x", position.x, final_value, duration)

# func tween_pos_y(final_value, duration: float,  trans: int = Tween.TRANS_QUART, _ease: int = Tween.EASE_OUT) -> TweenWrapper:
#     return Core.tween(self, "pos_y", final_value, duration, trans, _ease)

# func tween_pos(final_value, duration:   float,  trans: int = Tween.TRANS_QUART, _ease: int = Tween.EASE_OUT) -> TweenWrapper:
#     return Core.tween(self, "position", final_value, duration,  trans, _ease)
