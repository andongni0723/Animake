class_name StepFlow extends RefCounted

var queue: Array[TweenWrapper] = []

func add(tween: TweenWrapper) -> StepFlow:
    tween.wait()
    queue.append(tween)
    return self

func end() -> StepFlow:
    for i in queue:
        Core.add_anim_data(i.to_data())
    return self

func wait():
    return self
