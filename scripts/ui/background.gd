extends CanvasLayer

const BG_HEIGHT: float = 1920.0

var LEVEL_COLORS: Array[Color] = [
	Color.from_hsv(0.22, 1.0, 0.45),
	Color.from_hsv(0.27, 1.0, 0.45),
	Color.from_hsv(0.315, 1.0, 0.45),
	Color.from_hsv(0.355, 1.0, 0.45),
	Color.from_hsv(0.39, 1.0, 0.45),
	Color.from_hsv(0.42, 1.0, 0.45),
]

@export var player: CharacterBody2D
@onready var parallax: Parallax2D = $Parallax2D
@onready var tint: ColorRect = $ColorRect
@onready var level_label: Label = %Level

var _start_y: float
var _last_level: int = -2

func _ready() -> void:
	_start_y = player.global_position.y
	var lvl: int = 1
	_last_level = lvl
	tint.color = LEVEL_COLORS[posmod(lvl, LEVEL_COLORS.size())]
	level_label.text = str(lvl)

func _process(_delta: float) -> void:
	var lvl: int = max(0, floor((_start_y - player.global_position.y) / BG_HEIGHT))
	if lvl != _last_level:
		_last_level = lvl
		level_label.text = str(lvl)
		var color: Color = LEVEL_COLORS[posmod(lvl, LEVEL_COLORS.size())]
		var tween = create_tween()
		tween.tween_property(tint, "color", color, 1)
