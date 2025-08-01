class_name LassoController
extends Node2D

@export var default_lasso: LassoResource
@export var max_length = 120.0
@export var rest_length = 60.0
@export var stiffness = 80.0
@export var damping_factor = 2.0
@export var throw_speed = 20.0

var player: Player
var aim_direction: Vector2
var target: Vector2
var target_collider: Area2D
var hitch_point: Node2D
var hitched_texture: Texture2D
var is_hitched: bool
var is_throwing: bool
var strength_percent: float

@onready var state_machine: StateMachine = %LassoStateMachine
@onready var animation_player: AnimationPlayer = %LassoAnimationPlayer
@onready var lasso_raycast: RayCast2D = %LassoRaycast
@onready var lasso_line: Line2D = %LassoLine
@onready var lasso_root: Node2D = %LassoRoot
@onready var lasso_honda: AnimatedSprite2D = %LassoHonda
@onready var lasso_slack: Sprite2D = %LassoSlack


func _ready() -> void:
	#var DEFAULT_LASSO = load("uid://i0uqsngspksk")
	change_lasso(default_lasso)
	reset_rope()


func setup(_player: Player) -> void:
	player = _player
	state_machine.setup(self, animation_player)


func change_lasso(new_lasso: LassoResource) -> void:
	max_length = new_lasso.max_length
	rest_length = min(new_lasso.rest_length, max_length)
	throw_speed = new_lasso.throw_speed
	stiffness = new_lasso.stiffness
	damping_factor = new_lasso.damping_factor
	lasso_line.texture = new_lasso.rope_texture
	lasso_honda.sprite_frames = new_lasso.rope_honda_frames
	lasso_raycast.target_position = Vector2.RIGHT * max_length
	lasso_slack.texture = new_lasso.rope_slack_texture
	hitched_texture = new_lasso.hitched_texture


func aim_lasso() -> void:
	look_at(global_position + aim_direction)


func get_target_from_collision() -> void:
	if lasso_raycast.is_colliding():
		target = lasso_raycast.get_collision_point()


func hitch_lasso() -> bool:
	if lasso_raycast.is_colliding():
		is_hitched = true
		target_collider = lasso_raycast.get_collider()
		target = target_collider.global_position
		lasso_line.show()
		return true
	return false


func release_lasso() -> void:
	lasso_line.hide()
	state_machine.change_state("idle")


## Strain should be useful for rubber and ghost lassos
func swing(delta: float) -> void:
	var target_dir = global_position.direction_to(target)
	var target_dist = global_position.distance_to(target)
	var displacement = target_dist - rest_length
	var strain = displacement / max_length
	if strain > 0.9:
		release_lasso()
		return
		
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_dir)
		var damping = -damping_factor * vel_dot * target_dir
		
		force = spring_force + damping
	
	player.velocity += force * delta
	update_rope(strain)


func update_rope(strain: float, new_target: Vector2 = Vector2.ZERO, color: Color = Color.DARK_SALMON) -> void:
	var line_target = target if new_target == Vector2.ZERO else new_target
	lasso_line.set_point_position(1, to_local(line_target))
	lasso_line.material.set("shader_parameter/flash_color", color)
	lasso_line.material.set("shader_parameter/flash_intensity", strain * strain)


func reset_rope() -> void:
	lasso_line.clear_points()
	lasso_line.add_point(Vector2.ZERO)
	lasso_line.add_point(Vector2.ZERO)
	lasso_honda.hide()
	lasso_line.material.set("shader_parameter/flash_intensity", 0.0)


func segment_rope() -> void:
	var start_point := lasso_line.points[0]
	var end_point := lasso_line.points[1]
	var direction := start_point.direction_to(end_point)
	var segments := 5
	for i in segments:
		lasso_line.add_point(i * direction / segments)
