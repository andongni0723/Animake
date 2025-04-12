extends Node2D

var a: int = 0 :
    set(value):
        a = value

var b : int = 0 :
    set(value):
        pass


func _ready():
    a = 1
    print(a)
    b = 1
    print(b)