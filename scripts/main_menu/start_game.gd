extends TextureButton

@export var pressed_sfx: PackedScene


func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	$AnimationPlayer.play("tilt")


func _on_mouse_exited() -> void:
	$AnimationPlayer.stop()


func _on_pressed() -> void:
	if pressed_sfx:
		var sfx: AudioStreamPlayer = pressed_sfx.instantiate()
		get_tree().root.add_child(sfx)

	Globals.scene_entry = &"menu"
	var fade_animation_player: AnimationPlayer = Fade.get_node("AnimationPlayer")
	fade_animation_player.play("fade_out")
	await fade_animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/states/main.tscn")
