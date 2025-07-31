class_name LassoController
extends Node2D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping_factor = 2.0

var thrown: bool
var target: Vector2
var player: Player

@onready var lasso_raycast: RayCast2D = %LassoRaycast
@onready var lasso_line: Line2D = %LassoLine


func _process(delta: float) -> void:
	if thrown:
		handle_lasso(delta)


func init(_player: Player) -> void:
	player = _player


func throw_lasso() -> void:
	if lasso_raycast.is_colliding():
		thrown = true
		target = lasso_raycast.get_collision_point()
		lasso_line.show()


func release_lasso() -> void:
	thrown = false
	lasso_line.hide()


func handle_lasso(delta: float) -> void:
	var target_dir = global_position.direction_to(target)
	var target_dist = global_position.distance_to(target)
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping_factor * vel_dot * target_dir
		
		force = spring_force + damping
	
	player.velocity += force * delta
	update_rope()

func update_rope():
	lasso_line.set_point_position(1, to_local(target))
	pass
