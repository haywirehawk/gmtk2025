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
var _delta: float
var amount: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_timer = $MovementTimer
	movement_timer.timeout.connect(_move_randomly)
	left_hitbox.successful_hit.connect(_tornado_hit)
	right_hitbox.successful_hit.connect(_tornado_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_delta = delta
	move_and_slide()
	if amount != 0:
		amount -= 1
		if amount == 0:
			velocity.x = 0


#turns on/off random movement, can still move manually when off
func tornado_switch(on: bool) -> void:
	if on:
		_start_tornado()
	else:
		_stop_tornado()


func _start_tornado() -> void:
	movement_timer.start()
	_move_randomly()


func _stop_tornado() -> void:
	movement_timer.stop()


func _move_tornado() -> void:
	var target_velocity = speed * direction
	velocity.x = lerp(velocity.x, target_velocity, 1 - exp(-movement_damping * _delta))


#direction 1 = right, -1 = left
func move_manually(_direction: int, _amount: float) -> void:
	_update_direction(_direction)
	amount = _amount
	_move_tornado()


func _move_randomly() -> void:
	direction = randi_range(-1, 1)
	var move_sides_closer = randi_range(-1, 1)
	_update_direction(direction)
	_move_tornado()
	if move_sides_closer == 1:
		_move_sides(true)
	elif move_sides_closer == -1:
		_move_sides(false)


func _update_direction(_direction: int) -> void:
	direction = _direction


func adjust_width(closer: bool, amount: float) -> void:
	spread_speed = amount
	_move_sides(closer)


func _move_sides(closer: bool) -> void:
	if closer:
		_move_sides_closer()
	else:
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
