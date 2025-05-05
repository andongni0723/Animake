class_name RecordAnimationProcess extends Node


## Duplicate the animation player in TimelinePanel,
## and process the node path about prefix point to "Anime Node".
## @return The new animation player with the node path processed.
func duplicate_animation_player_and_process_node_path() -> AnimationPlayer:
    var animation_player: AnimationPlayer = UIManager.timeline_panel.animation_player.duplicate()
    var lib := animation_player.get_animation_library("")
    if not lib: return animation_player

    for anim_name in lib.get_animation_list():
        var anim := lib.get_animation(anim_name)

        for index in range(anim.get_track_count()):
            var cur_path := anim.track_get_path(index)
            var new_path = change_path_prefix(cur_path)
            anim.track_set_path(index, new_path)
    return animation_player


## Change the path prefix of a given path.
## change prefix which is [code]"Main Scene/Anime Node"[\code] string
## to [code]"Main Scene/Record Viewport/Anime Node Record"[\code].
## @param input The input path to change.
## @return The new path with the prefix changed.
func change_path_prefix(input: String) -> String:
    var prefix      := "Main Scene/Anime Node"
    var new_prefix  := "Main Scene/Record Viewport/Anime Node Record"
    return (new_prefix + input.substr(prefix.length())) if input.begins_with(prefix) else input
