extends Sprite2D


@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.body_entered.connect(_melt_ice)


func _melt_ice(_body: Node2D) -> void:
	var tween = create_tween()
	await tween.tween_property(self, "modulate:a", 0, 1).finished
	self.queue_free()
