extends ProgressBar

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
var _is_shaking: bool = false

func _ready() -> void:
	Events.flap_pressed.connect(_on_flap_pressed)


func _on_flap_pressed() -> void:
	value = max(value - 12, 0)


func _process(delta: float) -> void:
	if not is_instance_valid(Globals.player) or not Globals.player.call("is_active"):
		return

	var prev_value := value
	if value == 0:
		Events.health_depleted.emit()

	if prev_value > 25.0 and value <= 25.0:
		_animation_player.play("shake")
		_is_shaking = true
	elif _is_shaking and value > 25.0:
		_animation_player.stop()
		_animation_player.play("RESET")
		_is_shaking = false
