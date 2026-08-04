extends Camera2D

@export var player: CharacterBody2D
@export var follow_speed: float = 5.0
@export var falling_follow_speed: float = 10.0
@export var idle_bob_amplitude: float = 12.0
@export var idle_bob_frequency: float = 2.5

var _idle_time: float = 0.0

func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	_idle_time += delta
	var target_position := player.global_position
	if not player.call("is_active"):
		target_position.y += sin(_idle_time * TAU * idle_bob_frequency) * idle_bob_amplitude

	var current_follow_speed := follow_speed
	if player.call("is_active") and player.velocity.y > 0.0:
		current_follow_speed = falling_follow_speed

	global_position = global_position.lerp(target_position, current_follow_speed * delta)
