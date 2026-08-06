extends CenterContainer

@export var player: CharacterBody2D
@onready var texture_button: TextureButton = $VBoxContainer/TextureButton
@onready var animation_player: AnimationPlayer = texture_button.get_node("AnimationPlayer")


func _ready() -> void:
	texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	Events.health_depleted.connect(_on_health_depleted)
	texture_button.mouse_entered.connect(_on_mouse_entered)
	texture_button.mouse_exited.connect(_on_mouse_exited)
	texture_button.pressed.connect(_on_retry_pressed)


func _on_health_depleted() -> void:
	show()


func _on_mouse_entered() -> void:
	animation_player.play("tilt")


func _on_mouse_exited() -> void:
	animation_player.stop()


func _on_retry_pressed() -> void:
	var player_height: int = int(player.get("highest_height"))
	if player_height > Data.high_score:
		Data.high_score = player_height
	Data.coins = 0
	Globals.scene_entry = &"retry"
	var fade_animation_player: AnimationPlayer = Fade.get_node("AnimationPlayer")
	fade_animation_player.play("reset_scene")
