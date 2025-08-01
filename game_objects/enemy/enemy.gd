class_name BaseEnemy
extends CharacterBody2D

@export var movement_damping := 15.0
@export var stopping_damping := 3.0
@export var move_speed := 40.0
@export var near_target_distance := 24.0
@export var target_distance := 150.0


# Timers
@onready var target_acquisition_timer: Timer = $Timers/TargetAcquisitionTimer
@onready var attack_cooldown_timer: Timer = $Timers/AttackCooldownTimer
@onready var attack_timer: Timer = $Timers/ReadyAttackTimer
# Components
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var state_machine: StateMachine = $StateMachine
# Visuals
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var default_gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_position: Vector2
var default_collision_mask: int
var default_collision_layer: int

var current_state: State:
	get:
		return state_machine.current_state
	set(value):
		state_machine.change_state(value.to_string())


func _ready() -> void:
	state_machine.setup($".", animated_sprite)
	default_collision_mask = collision_mask
	default_collision_layer = collision_layer
	#hitbox_collision_shape.disabled = true
	health_component.died.connect(_died)
	hurtbox_component.hurtbox_triggered.connect(_on_hit_by_hitbox)


func _process(delta: float) -> void:
	move_and_slide()
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		animated_sprite.scale = Vector2(-move_sign, 1)


func _physics_process(delta: float) -> void:
	apply_gravity(delta)


func apply_gravity(delta: float, gravity: float = default_gravity) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta


func enter_state_spawn() -> void:
	state_machine.change_state('Walk')


func state_spawn() -> void:
	enter_state_spawn()


func enter_state_idle() -> void:
	animated_sprite.play("Idle")


func state_idle() -> void:
	enter_state_idle()


func enter_state_walk() -> void:
	animated_sprite.play("Walk")
	acquire_target()
	target_acquisition_timer.start()


func state_walk() -> void:
	enter_state_walk()
	set_movement_velocity(get_physics_process_delta_time())
	check_acquire_target()
	if can_attack():
		state_machine.change_state('Attack')


func exit_state_walk() -> void:
	animated_sprite.stop()


func enter_state_attack() -> void:
	acquire_target()
	attack_timer.start()
	animated_sprite.play("Attack")


func state_attack() -> void:
	velocity = velocity.lerp(Vector2.ZERO, 1.0 - exp(-movement_damping * get_process_delta_time()))
	if attack_timer.is_stopped() && can_attack():
		enter_state_attack()
	elif not can_attack():
		state_machine.change_state('Walk')


func exit_state_attack() -> void:
	animated_sprite.stop()


func set_movement_velocity(delta: float) -> void:
	velocity = global_position.direction_to(target_position) * move_speed


func check_acquire_target() -> void:
	if target_acquisition_timer.is_stopped():
		acquire_target()
		target_acquisition_timer.start()


func acquire_target() -> void:
	var player = $"../../Player"
	target_position = player.global_position


func can_attack() -> bool:
		var can_attack := attack_cooldown_timer.is_stopped()\
			or global_position.distance_squared_to(target_position) < near_target_distance * near_target_distance
		
		if can_attack and global_position.distance_squared_to(target_position) < target_distance * target_distance:
			return true
		return false


func _died() -> void:
	GameEvents.emit_enemy_died()
	queue_free()


func _on_hit_by_hitbox() -> void:
	pass
