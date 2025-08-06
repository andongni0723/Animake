class_name RecordAnimationProcess extends Node


## Duplicate the animation player in TimelinePanel,
## and process the node path about prefix point to "Anime Node".
## @return The new animation player with the node path processed.
func duplicate_animation_player_and_process_node_path() -> AnimationPlayer:
    var new_player := AnimationPlayer.new()
    var new_lib := AnimationLibrary.new()
    new_player.add_animation_library("", new_lib)

    var src_player : AnimationPlayer = UIManager.timeline_panel.animation_player
    var src_lib    : AnimationLibrary = src_player.get_animation_library("")

    for anim_name in src_lib.get_animation_list():
        var anim_src : Animation = src_lib.get_animation(anim_name)
        var anim_dup : Animation = anim_src.duplicate(true)

        for track_id in anim_dup.get_track_count():
            var p : NodePath = anim_dup.track_get_path(track_id)
            anim_dup.track_set_path(track_id, change_path_prefix(p))

        new_lib.add_animation(anim_name, anim_dup)

    return new_player


## Change the path prefix of a given path.
## change prefix which is [code]"Main Scene/Anime Node"[\code] string
## to [code]"Main Scene/Record Viewport/Anime Node Record"[\code].
## @param input The input path to change.
## @return The new path with the prefix changed.
func change_path_prefix(input: String) -> String:
    var prefix      := "Main Scene/Anime Node"
    var new_prefix  := "Main Scene/Record Viewport/Anime Node Record"
    return (new_prefix + input.substr(prefix.length())) if input.begins_with(prefix) else input
