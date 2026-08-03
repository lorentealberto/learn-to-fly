extends TextureButton

@export var points_spawner: Node2D
const PRESSED_SFX: PackedScene = preload("res://scenes/effects/sfx/pressed_sfx.tscn")

@onready var price: Label = $MarginContainer/VBoxContainer/Price
@onready var level: Label = $MarginContainer/VBoxContainer/Level

var upgrade_level: int = 1
var upgrade_price: int = 20

func _ready():
	focus_mode = Control.FOCUS_NONE
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	price.text = str(upgrade_price)
	level.text = "Level " + str(upgrade_level)
	_update_spawner()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)


func _on_mouse_entered():
	$AnimationPlayer.play("tilt")


func _on_mouse_exited():
	$AnimationPlayer.stop()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrade_more_food"):
		_on_pressed()


func _update_spawner():
	points_spawner.set_spawn_level(upgrade_level)

func _on_pressed():
	get_tree().root.add_child(PRESSED_SFX.instantiate())
	if Data.coins >= upgrade_price:
		Data.coins -= upgrade_price
		upgrade_level += 1
		upgrade_price = ceil(upgrade_price * 1.15)
		price.text = str(upgrade_price)
		level.text = "Level " + str(upgrade_level)
		_update_spawner()
		Events.coins_updated.emit()
		$AnimationPlayer.play("tilt")
