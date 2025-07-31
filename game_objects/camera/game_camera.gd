extends Camera2D

const MOTION_DAMPING: float = 3.0

@export var target: Node2D


func _ready() -> void:
	if target:
		global_position = target.global_position


func _process(delta: float) -> void:
	follow_target(delta)


func follow_target(delta: float) -> void:
	if is_instance_valid(target):
		global_position = lerp(global_position, target.global_position, 1 - exp(-MOTION_DAMPING * delta))
