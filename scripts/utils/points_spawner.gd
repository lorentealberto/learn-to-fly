extends Node2D

@export var player: CharacterBody2D
@export var spawn_distance: float = 1000.0
@export var spawn_ahead_distance: float = 150.0
@export var points_multiplier: float = 1.0

const POINT_SCENE: PackedScene = preload("res://scenes/prefabs/point.tscn")

const BASE_POINT_COUNT: int = 3
const DIAGONAL_MIN_POINTS: int = 5
const ARC_MIN_POINTS: int = 5
const CLUSTER_MIN_POINTS: int = 6
const PATTERN_WIDTH: float = 760.0
const PATTERN_HEIGHT: float = 400.0
const CLUSTER_WIDTH: float = 280.0
const CLUSTER_HEIGHT: float = 160.0
const PLAYFIELD_MARGIN: float = 120.0

var _next_spawn_y: float
var _last_wave_y: float = INF

func _ready() -> void:
	if is_instance_valid(player):
		_next_spawn_y = player.global_position.y - spawn_distance


func _process(_delta: float) -> void:
	if not is_instance_valid(player) or not player.call("is_active"):
		return

	while player.global_position.y <= _next_spawn_y:
		_spawn_wave()
		_next_spawn_y -= spawn_distance


func set_spawn_level(level: int) -> void:
	points_multiplier = maxf(1.0, level)


func _spawn_wave() -> void:
	var wave_y: float = _next_wave_y()
	_last_wave_y = wave_y
	var center := Vector2(player.global_position.x, wave_y)
	var point_count: int = ceili(BASE_POINT_COUNT * points_multiplier)
	var pattern: int = randi_range(0, 2)

	match pattern:
		0:
			_spawn_diagonal(center, point_count)
		1:
			_spawn_arc(center, point_count)
		2:
			_spawn_cluster(center, point_count)


func _next_wave_y() -> float:
	return minf(_camera_top_y() - spawn_ahead_distance, _last_wave_y - spawn_distance)


func _camera_top_y() -> float:
	var camera := get_viewport().get_camera_2d()
	if not is_instance_valid(camera):
		return player.global_position.y - spawn_ahead_distance
	var half_height: float = get_viewport().get_visible_rect().size.y * 0.5 / camera.zoom.y
	return camera.global_position.y - half_height


func _spawn_diagonal(center: Vector2, point_count: int) -> void:
	var direction: float = 1.0 if player.get("direction") >= 0 else -1.0
	var pattern_center_x: float = _get_pattern_center_x(PATTERN_WIDTH)
	var start_x: float = pattern_center_x - PATTERN_WIDTH * 0.5
	var pattern_points: int = maxi(point_count, DIAGONAL_MIN_POINTS)

	for index in pattern_points:
		var progress: float = float(index) / (pattern_points - 1)
		var point_position := Vector2(
			start_x + progress * PATTERN_WIDTH if direction > 0 else start_x + (1.0 - progress) * PATTERN_WIDTH,
			center.y - progress * PATTERN_HEIGHT
		)
		_spawn_point(point_position)


func _spawn_arc(center: Vector2, point_count: int) -> void:
	var pattern_center_x: float = _get_pattern_center_x(PATTERN_WIDTH)
	var start_x: float = pattern_center_x - PATTERN_WIDTH * 0.5
	var pattern_points: int = maxi(point_count, ARC_MIN_POINTS)

	for index in pattern_points:
		var progress: float = float(index) / (pattern_points - 1)
		var x: float = start_x + progress * PATTERN_WIDTH
		var y: float = center.y - sin(progress * PI) * PATTERN_HEIGHT
		_spawn_point(Vector2(x, y))


func _spawn_cluster(center: Vector2, point_count: int) -> void:
	var pattern_center_x: float = _get_pattern_center_x(CLUSTER_WIDTH)
	var pattern_points: int = maxi(point_count, CLUSTER_MIN_POINTS)

	for index in pattern_points:
		var angle: float = TAU * index / pattern_points
		var offset := Vector2(
			cos(angle) * CLUSTER_WIDTH * 0.5,
			sin(angle) * CLUSTER_HEIGHT * 0.5
		)
		_spawn_point(Vector2(pattern_center_x, center.y) + offset)


func _get_pattern_center_x(pattern_width: float) -> float:
	var viewport_width: float = get_viewport_rect().size.x
	var min_center: float = PLAYFIELD_MARGIN + pattern_width * 0.5
	var max_center: float = viewport_width - PLAYFIELD_MARGIN - pattern_width * 0.5
	return clampf(player.global_position.x, min_center, max_center)


func _spawn_point(point_position: Vector2) -> void:
	var point := POINT_SCENE.instantiate()
	add_child(point)
	point.global_position = point_position
