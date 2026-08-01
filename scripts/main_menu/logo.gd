extends TextureRect

var time: float = 0.0
var original_position: Vector2

func _ready():
	original_position = position

func _process(delta: float) -> void:
	time += delta
	# Sine wave: amplitude of 10 pixels, speed of 2 rad/s
	position.y = original_position.y + sin(time * 2.0) * 10.0
