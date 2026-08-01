extends Node2D

@export var player: CharacterBody2D
const POINT_SCENE: PackedScene = preload("res://scenes/prefabs/point.tscn")

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	set_spawn_level(1)

func set_spawn_level(level: int) -> void:
	if timer:
		timer.wait_time = max(0.05, 0.9 - 0.08 * (level - 1))
		timer.start()


func _on_timer_timeout() -> void:
	if player.velocity.y >= 0:
		return

	var point: Area2D = POINT_SCENE.instantiate()
	add_child(point)
	point.global_position.y = player.global_position.y - 1920
