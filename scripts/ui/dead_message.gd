extends CenterContainer

@onready var texture_button: TextureButton = $VBoxContainer/TextureButton
@onready var animation_player: AnimationPlayer = texture_button.get_node("AnimationPlayer")


func _ready() -> void:
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
	Data.coins = 0
	get_tree().reload_current_scene()
