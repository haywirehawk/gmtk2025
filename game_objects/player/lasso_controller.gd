extends Node2D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0

var thrown: bool
var target: Vector2

@onready var lasso_raycast: RayCast2D = %LassoRaycast
@onready var lasso_line: Line2D = %LassoLine


func _process(delta: float) -> void:
	if thrown:
		handle_lasso(delta)


func throw_lasso() -> void:
	pass


func release_lass() -> void:
	pass


func handle_lasso(delta: float) -> void:
	pass
