class_name Create

static var object_detail: AnimakeObjectDetail = preload("res://Data/Object Data/object_detail.tres")
static var square_detail: AnimakeObjectDetail = preload("res://Data/Object Data/square_detail.tres")
static var text_detail: AnimakeObjectDetail   = preload("res://Data/Object Data/text_detail.tres")
static var panel_detail: AnimakeObjectDetail  = preload("res://Data/Object Data/panel_detail.tres")

static func _init() -> void:
    # square_detail = load(DATA_PATH)
    if square_detail == null:
        printerr("SquareDetail.tres not found")
    if text_detail == null:
        printerr("TextDetail.tres not found")
    if object_detail == null:
        printerr("ObjectDetail.tres not found")

static func make_object(name: String, pos: Vector2 = Vector2.ZERO) -> BaseObject:
    return Core.spawn(object_detail.prefab, name, pos, 0) as BaseObject

static func make_square(name: String, pos: Vector2 = Vector2.ZERO) -> Square:
    return Core.spawn(square_detail.prefab, name, pos, 0) as Square

static func make_panel(name: String, pos: Vector2 = Vector2.ZERO) -> ImagePanel:
    return Core.spawn(panel_detail.prefab, name, pos, 0) as ImagePanel

static func make_text(name: String, pos: Vector2 = Vector2.ZERO) -> Text:
    return Core.spawn(text_detail.prefab, name, pos, 0) as Text
