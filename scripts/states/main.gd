extends Node2D


func _ready() -> void:
	Events.fade_halfway.connect(_on_fade_halfway)
	var animation_name: StringName
	match Globals.scene_entry:
		&"menu":
			animation_name = &"fade_in"
		&"retry":
			animation_name = &"reset_scene"
		_:
			return

	Globals.scene_entry = &""
	var fade_animation_player: AnimationPlayer = Fade.get_node("AnimationPlayer")
	fade_animation_player.play(animation_name)


func _on_fade_halfway() -> void:
	if Globals.scene_entry != &"retry":
		return
	Globals.scene_entry = &""
	get_tree().reload_current_scene()
