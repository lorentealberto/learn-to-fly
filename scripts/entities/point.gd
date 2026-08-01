extends Area2D

@onready var spr: Sprite2D = $Sprite2D
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	position.x = randf_range(20, 1060)
	notifier.screen_exited.connect(queue_free)
