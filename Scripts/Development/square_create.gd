class_name SquareCreate

# const DATA_PATH: String = "res://PrefabData/SquareDetail.tres"
static var square_detail: SquareDetail = preload("res://Data/SquareDetail.tres")

static func _init() -> void:
	# square_detail = load(DATA_PATH)
	if square_detail == null:
		printerr("SquareDetail.tres not found")


static func make_square(pos: Vector2) -> Square:
	return GameManager.spawn(square_detail.basic_square, pos, 0) as Square
