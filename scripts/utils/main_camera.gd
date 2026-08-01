extends Camera2D

@export var player: CharacterBody2D
@export var follow_speed: float = 5.0

func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	global_position = global_position.lerp(player.global_position, follow_speed * delta)
