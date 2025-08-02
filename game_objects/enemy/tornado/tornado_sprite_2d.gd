class_name TornadoSprite
extends Sprite2D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func move(speed: float, direction: int) -> void:
	var target_velocity = speed * direction
	var tween := create_tween()
	tween.tween_property(self, "position", Vector2(position.x + target_velocity, position.y), 1.0)
