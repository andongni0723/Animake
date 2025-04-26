class_name AllFlow extends RefCounted

var queue: Array[TweenWrapper] = []

func add(tween: TweenWrapper) -> AllFlow:
    queue.append(tween)
    return self

func end() -> AllFlow:
    for i in queue:
        Core.add_anim_data(i.to_data())
    return self

func wait():
    queue[queue.size() - 1].wait()
    return self
