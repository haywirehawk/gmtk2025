class_name Tornado
extends Node2D


@export var move_speed: float = 10
@export var spread_speed: float = 50
@export var movement_damping: float = 0.5

#@onready var left_side: TornadoSprite = $LeftSprite2D
#@onready var right_side: TornadoSprite = $RightSprite2D
@onready var left_hitbox: HitboxComponent = $LeftWall/HitboxComponent
@onready var right_hitbox: HitboxComponent = $RightWall/HitboxComponent
@onready var left_wall: TornadoSprite = %LeftWall
@onready var right_wall: TornadoSprite = %RightWall


var movement_timer: Timer
var direction: int = 1
#var _delta: float
var amount: float = 0

var target: Node2D
var idle: bool
var _closing_speed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_hitbox.successful_hit.connect(_tornado_hit)
	right_hitbox.successful_hit.connect(_tornado_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if idle: return
	
	follow_target(delta)
	close_walls(delta)


func setup(new_target: Node2D) -> void:
	target = new_target
	global_position.x = target.global_position.x


func start_tornado() -> void:
	idle = false


func stop_tornado() -> void:
	idle = true


func set_closing_speed(speed: float) -> void:
	_closing_speed = speed


func follow_target(delta: float) -> void:
	if target:
		global_position.x = lerp(global_position.x, target.global_position.x, 1 - exp(-movement_damping * delta))


func close_walls(delta: float) -> void:
	if left_wall.position.x >= 0:
		return
	var closing_distance = _closing_speed * delta
	left_wall.position.x += closing_distance
	right_wall.position.x -= closing_distance
	


#turns on/off random movement, can still move manually when off
#func tornado_switch(on: bool) -> void:
	#if on:
		#_start_tornado()
	#else:
		#_stop_tornado()


#func _move_tornado() -> void:
	#var target_velocity = speed * direction
	#velocity.x = lerp(velocity.x, target_velocity, 1 - exp(-movement_damping * _delta))


#direction 1 = right, -1 = left
#func move_manually(_direction: int, _amount: float) -> void:
	#_update_direction(_direction)
	#amount = _amount
	#_move_tornado()


#func _move_randomly() -> void:
	#direction = randi_range(-1, 1)
	#var move_sides_closer = randi_range(-1, 1)
	#_update_direction(direction)
	#_move_tornado()
	#if move_sides_closer == 1:
		#_move_sides(true)
	#elif move_sides_closer == -1:
		#_move_sides(false)


#func _update_direction(_direction: int) -> void:
	#direction = _direction
#
#
#func adjust_width(closer: bool, _amount: float) -> void:
	#spread_speed = _amount
	#_move_sides(closer)
#
#
#func _move_sides(closer: bool) -> void:
	#if closer:
		#_move_sides_closer()
	#else:
		#_move_sides_farther()
#
#
#func _move_sides_closer() -> void:
	#left_side.move(spread_speed, 1)
	#right_side.move(spread_speed, -1)
##
##
#func _move_sides_farther() -> void:
	#left_side.move(spread_speed, -1)
	#right_side.move(spread_speed, 1)


func _tornado_hit(_direction: Vector2) -> void:
	GameEvents.tornado_hit.emit()
