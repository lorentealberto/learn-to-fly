extends Label

func _ready() -> void:
	Events.coins_updated.connect(_on_coins_updated)

func _on_coins_updated() -> void:
	text = "%06d" % Data.coins
