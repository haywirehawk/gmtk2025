class_name LassoHitchComponent
extends Sprite2D

var origin_point: Vector2


func _ready() -> void:
	if origin_point:
		rotation = get_angle_to(origin_point)
