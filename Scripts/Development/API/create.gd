class_name Create

static var object_detail: ObjectDetail = preload("res://Data/object_detail.tres")
static var square_detail: SquareDetail = preload("res://Data/square_detail.tres")
static var text_detail:	TextDetail = preload("res://Data/text_detail.tres")

static func	_init()	-> void:
	# square_detail	= load(DATA_PATH)
	if square_detail == null:
		printerr("SquareDetail.tres	not	found")
	if text_detail == null:
		printerr("TextDetail.tres not found")
	if object_detail == null:
		printerr("ObjectDetail.tres	not	found")

static func	make_object(name: String, pos: Vector2 = Vector2.ZERO) -> Node2D:
	return Core.spawn(object_detail.empty_object, name, pos, 0) as Node2D

static func	make_square(name: String, pos: Vector2 = Vector2.ZERO) -> Square:
	return Core.spawn(square_detail.basic_square, name, pos, 0) as Square

static func	make_text(name:	String,	pos: Vector2 = Vector2.ZERO) -> Text:
	return Core.spawn(text_detail.basic_text, name, pos, 0) as Text
