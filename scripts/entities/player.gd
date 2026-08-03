extends CharacterBody2D

@export var gravity: float = 1200.0
@export var flap_force: float = -400.0
@export var flap_cooldown: float = 0.5
@export var speed: float = 150.0
@export var tilt_angle: float = 10.0
@export var flap_sfx: PackedScene
@export var coin_sfx: PackedScene

var _flap_timer: float
var _flap_buffer: int
var _can_flap: bool = true
var _started: bool = false

var direction: int = 1:
	set(value):
		if direction != value:
			direction = value
			_update_tilt()
var _tween: Tween

@onready var area_2d: Area2D = $Area2D
@onready var character: Node2D = $Character
@onready var animation: AnimationPlayer = $Character/AnimationPlayer
@export var health_bar: ProgressBar


func _ready() -> void:
	_flap_timer = flap_cooldown
	animation.play("flap_loop")
	Globals.player = self
	area_2d.area_entered.connect(_on_area_entered)
	Events.health_depleted.connect(_on_health_depleted)


func is_active() -> bool:
	return _started


func _on_area_entered(_area: Area2D) -> void:
	_area.queue_free()
	Data.coins += 1
	Events.coins_updated.emit()
	health_bar.value += health_bar.max_value * 0.1
	var sfx: AudioStreamPlayer = coin_sfx.instantiate()
	get_tree().root.add_child(sfx)
	

func _update_tilt() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(character, "rotation", deg_to_rad(tilt_angle * direction), 0.05)


func _unhandled_input(event: InputEvent) -> void:
	if _can_flap and event.is_action_pressed("flap"):
		_started = true
		_update_tilt()
		_flap_buffer = mini(_flap_buffer + 1, 1)
	if _can_flap and event.is_action_released("flap"):
		_flap_buffer = 0

func _process(delta: float) -> void:
	_flap_timer += delta
	if not _started:
		return

	velocity.y += gravity * delta

	if _can_flap and _flap_timer >= flap_cooldown and _flap_buffer > 0:
		_flap_buffer -= 1
		velocity.y = flap_force
		Events.flap_pressed.emit()
		animation.play("flap")
		var sfx: AudioStreamPlayer = flap_sfx.instantiate()
		get_tree().root.add_child(sfx)
		_flap_timer = 0.0

	velocity.x = direction * speed
	move_and_slide()

	var screen_width: float = get_viewport_rect().size.x
	if global_position.x < 100:
		global_position.x = 100
		direction = 1
	elif global_position.x > screen_width - 100:
		global_position.x = screen_width - 100
		direction = -1

func _on_health_depleted() -> void:
	_can_flap = false
