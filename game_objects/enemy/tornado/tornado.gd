extends CharacterBody2D


@export var speed: float = 10
@export var spread_speed: float = 50
@export var movement_damping: float = 5.0

@onready var left_side: TornadoSprite = $LeftSprite2D
@onready var right_side: TornadoSprite = $RightSprite2D
@onready var left_hitbox: HitboxComponent = $LeftSprite2D/HitboxComponent
@onready var right_hitbox: HitboxComponent = $RightSprite2D/HitboxComponent


var movement_timer: Timer
var direction: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_timer = $MovementTimer
	movement_timer.timeout.connect(_update_direction)
	movement_timer.start()
	left_hitbox.successful_hit.connect(_tornado_hit)
	right_hitbox.successful_hit.connect(_tornado_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var target_velocity = speed * direction
	velocity.x = lerp(velocity.x, target_velocity, 1 - exp(-movement_damping * delta))
	move_and_slide()


func _update_direction() -> void:
	direction = randi_range(-1, 1)
	var move_sides_closer = randi_range(-1, 1)
	if move_sides_closer == 1:
		_move_sides_closer()
	elif move_sides_closer == -1:
		_move_sides_farther()


func _move_sides_closer() -> void:
	left_side.move(spread_speed, 1)
	right_side.move(spread_speed, -1)
#
#
func _move_sides_farther() -> void:
	left_side.move(spread_speed, -1)
	right_side.move(spread_speed, 1)


func _tornado_hit(_direction: Vector2) -> void:
	GameEvents.tornado_hit.emit()
