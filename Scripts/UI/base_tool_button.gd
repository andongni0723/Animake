@tool
extends BaseButton


@export var icon: CompressedTexture2D = null:
    set(value):
        if texture_rect:
            texture_rect.texture = value
    get():
        return texture_rect.texture

@export var texture_rect: TextureRect

func _ready():
    pass
