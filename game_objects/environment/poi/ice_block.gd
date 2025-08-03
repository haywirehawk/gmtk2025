extends Sprite2D


@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.body_entered.connect(_melt_ice)


func _melt_ice(body: Node2D) -> void:
	self.queue_free()
