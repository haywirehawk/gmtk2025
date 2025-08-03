class_name LassoController
extends Node2D

const DEFAULT_SHADER: Shader = preload("uid://bxa23hv7qmfki")

enum LassoTag {
	NONE,
	FIRE,
	GHOST,
	RUBBER,
}

@export var default_lasso: LassoResource
# Lasso Stats
var max_length = 120.0
var rest_length = 60.0
var stiffness = 80.0
var damping_factor = 2.0
var throw_speed = 20.0

var player: Player
var aim_direction: Vector2
var target: Vector2
var target_collider: Area2D
var hitch_point: Node2D
var hitched_texture: Texture2D
var strength_percent: float
var tag: LassoTag = LassoTag.NONE
var is_rubber: bool = false


var particles_array: Array[Node]

@onready var state_machine: StateMachine = %LassoStateMachine
@onready var animation_player: AnimationPlayer = %LassoAnimationPlayer
@onready var lasso_raycast: RayCast2D = %LassoRaycast
@onready var lasso_line: Line2D = %LassoLine
@onready var lasso_root: Node2D = %LassoRoot
@onready var lasso_honda_area: CharacterBody2D = %LassoHondaArea
@onready var lasso_honda_sprite: AnimatedSprite2D = %LassoHondaSprite
@onready var lasso_slack: Sprite2D = %LassoSlack


func _ready() -> void:
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
	lasso_honda_sprite.sprite_frames = new_lasso.rope_honda_frames
	lasso_raycast.target_position = Vector2.RIGHT * max_length
	lasso_slack.texture = new_lasso.rope_slack_texture
	hitched_texture = new_lasso.hitched_texture
	tag = new_lasso.tag
	
	is_rubber = tag == LassoTag.RUBBER
	change_collision_from_tag()
	set_shaders_and_particles(new_lasso)
	
	if state_machine.current_state.name.to_lower() == "locked":
		state_machine.change_state("idle")


func change_collision_from_tag() -> void:
	if tag == LassoTag.FIRE:
		lasso_honda_area.collision_layer = 96
	else:
		lasso_honda_area.collision_layer = 32


func set_shaders_and_particles(lasso: LassoResource) -> void:
	var new_material := ShaderMaterial.new()
	if lasso.shader:
		new_material.shader = lasso.shader
	else:
		new_material.shader = DEFAULT_SHADER
	lasso_honda_sprite.material = new_material
	lasso_slack.material = new_material
	
	for node in particles_array:
		node.queue_free()
	particles_array.clear()
	
	if lasso.particles:
		var particles1: Node = lasso.particles.instantiate()
		var particles2: Node = lasso.particles.instantiate()
		lasso_honda_area.add_child(particles1)
		lasso_slack.add_child(particles2)
		particles_array.append(particles1)
		particles_array.append(particles2)


func aim_lasso() -> void:
	look_at(global_position + aim_direction)


func get_target_from_collision() -> void:
	if lasso_raycast.is_colliding():
		target = lasso_raycast.get_collision_point()


func hitch_lasso() -> bool:
	if lasso_raycast.is_colliding():
		target_collider = lasso_raycast.get_collider()
		target = target_collider.global_position
		lasso_line.show()
		return true
	return false


func release_lasso() -> void:
	lasso_line.hide()
	state_machine.change_state("idle")


func get_climb_direction() -> float:
	return -player.move_direction_y


## Strain should be useful for rubber and ghost lassos
func swing(delta: float) -> void:
	var target_direction = global_position.direction_to(target)
	var target_distance = global_position.distance_to(target)
	var displacement = target_distance - rest_length
	var strain = displacement / max_length
	if strain > 0.9:
		release_lasso()
		return
		
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_direction * spring_force_magnitude
		
		var vel_dot = player.velocity.dot(target_direction)
		var damping = -damping_factor * vel_dot * target_direction
		
		if is_rubber and player.input_jump_just_pressed:
			force = spring_force * 2
			release_lasso()
		else:
			force = spring_force + damping
	
	if player.is_on_floor():
		force *= .75
	
	var climb_direction = get_climb_direction()
	var climb_velocity = climb_direction * target_direction * 100
	
	player.velocity += (force + climb_velocity) * delta
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
	lasso_honda_area.hide()
	lasso_line.material.set("shader_parameter/flash_intensity", 0.0)


func segment_rope() -> void:
	var start_point := lasso_line.points[0]
	var end_point := lasso_line.points[1]
	var direction := start_point.direction_to(end_point)
	var segments := 5
	for i in segments:
		lasso_line.add_point(i * direction / segments)
