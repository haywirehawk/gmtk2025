class_name Player
extends CharacterBody2D

const BASE_MOVE_SPEED: float = 120.0
const MAX_MOVE_SPEED: float = 250.0
const BASE_MOVEMENT_DAMPING: float = 5.0
const JUMP_VELOCITY: float = -250.0
const JUMP_CANCEL_FACTOR: float = 0.75
const AIRBORNE_MOVEMENT_FACTOR: float = 250.0

# TODO: Remove, for testing only
@export var starting_lasso: LassoResource

# Movement
var default_gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_direction_x: float
var is_jumping: bool
# Inputs
var aim_vector: Vector2
var mouse_aim_vector: Vector2
var joypad_aim_vector: Vector2
var input_jump_held: bool
var input_jump_just_pressed: bool
var input_lasso_held: bool
var input_lasso_just_pressed: bool
var joystick_mode: bool

@onready var visuals: Node2D = $Visuals
@onready var aim_root: Node2D = %AimRoot
@onready var direction_arrow: Sprite2D = %DirectionArrow
@onready var lasso_controller: LassoController = %LassoController
@onready var lasso_raycast: RayCast2D = %LassoRaycast
@onready var lasso_line: Line2D = %LassoLine


func _ready() -> void:
	lasso_controller.setup(self)
	_change_lasso(starting_lasso)


func _process(_delta: float) -> void:
	update_aim_position()
	move_and_slide()
	if check_out_of_bounds():
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	get_inputs()
	handle_jump()
	handle_walking_movement(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		joystick_mode = true
	else:
		joystick_mode = false


func setup(lasso: LassoResource) -> void:
	_change_lasso(lasso)


func check_out_of_bounds() -> bool:
	if global_position.y > 5_000: return true
	else: return false


func get_inputs() -> void:
	move_direction_x = Input.get_axis("move_left", "move_right")
	mouse_aim_vector = aim_root.global_position.direction_to(aim_root.get_global_mouse_position())
	joypad_aim_vector = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	input_jump_just_pressed = Input.is_action_just_pressed("jump")
	input_jump_held = Input.is_action_pressed("jump")
	input_lasso_just_pressed = Input.is_action_just_pressed("lasso")
	input_lasso_held = Input.is_action_pressed("lasso")
	
	if joystick_mode:
		aim_vector = joypad_aim_vector
	else:
		aim_vector = mouse_aim_vector
		# Restricts keyboard movement to cardinals to avoid unintended joypad inputs.
		#movement_vector = movement_vector.snapped(Vector2(1.0, 1.0)).normalized()


func update_aim_position() -> void:
	visuals.scale = Vector2.ONE if aim_vector.x >= 0 else Vector2(-1, 1)
	if is_zero_approx(aim_vector.length_squared()):
		direction_arrow.hide()
	else:
		direction_arrow.look_at(aim_root.global_position + aim_vector)
		lasso_controller.aim_direction = aim_vector


func apply_gravity(delta: float, gravity: float = default_gravity) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta


func handle_walking_movement(delta: float) -> void:
	if is_on_floor():
		var target_velocity := move_direction_x * BASE_MOVE_SPEED
		velocity.x = lerpf(velocity.x, target_velocity, 1 - exp(-BASE_MOVEMENT_DAMPING * delta))
	else:
		var nudge := move_direction_x * AIRBORNE_MOVEMENT_FACTOR * delta
		velocity.x = clampf(velocity.x + nudge, -MAX_MOVE_SPEED, MAX_MOVE_SPEED)


func handle_jump() -> void:
	if input_jump_just_pressed and is_on_floor() and not is_jumping:
		velocity.y += JUMP_VELOCITY
		is_jumping = true
	if not input_jump_held and is_jumping:
		velocity.y *= JUMP_CANCEL_FACTOR
		is_jumping = false


## Wrapper for accessing the LassoController's change_lasso function with only a player reference.
## Returns true if successful, false otherwise. Checks on the lasso_controller's state_machine first.
func try_change_lasso(new_lasso: LassoResource) -> bool:
	if lasso_controller.state_machine.current_state.name == "idle":
		_change_lasso(new_lasso)
		return true
	return false


func _change_lasso(new_lasso: LassoResource) -> void:
	lasso_controller.change_lasso(new_lasso)
