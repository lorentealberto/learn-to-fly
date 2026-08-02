extends TextureButton

@export var player: CharacterBody2D
const PRESSED_SFX: PackedScene = preload("res://scenes/effects/sfx/pressed_sfx.tscn")

@onready var price: Label = $MarginContainer/VBoxContainer/Price
@onready var level: Label = $MarginContainer/VBoxContainer/Level

var upgrade_level: int = 1
var upgrade_price: int = 1

func _ready():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	price.text = str(upgrade_price)
	level.text = "Level " + str(upgrade_level)
	_update_player()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)


func _on_mouse_entered():
	$AnimationPlayer.play("tilt")


func _on_mouse_exited():
	$AnimationPlayer.stop()


func _update_player():
	player.speed = 150.0 * sqrt(upgrade_level)

func _on_pressed():
	get_tree().root.add_child(PRESSED_SFX.instantiate())
	if Data.coins >= upgrade_price:
		Data.coins -= upgrade_price
		upgrade_level += 1
		upgrade_price = ceil(upgrade_price * 1.15)
		price.text = str(upgrade_price)
		level.text = "Level " + str(upgrade_level)
		_update_player()
		Events.coins_updated.emit()
