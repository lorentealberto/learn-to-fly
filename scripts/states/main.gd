extends Node2D


func _ready() -> void:
	var animation_name: StringName
	match Globals.scene_entry:
		&"menu":
			animation_name = &"fade_in"
		&"retry":
			animation_name = &"fade_in_2"
		_:
			return

	Globals.scene_entry = &""
	var fade_animation_player: AnimationPlayer = Fade.get_node("AnimationPlayer")
	fade_animation_player.play(animation_name)
