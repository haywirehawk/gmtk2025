extends State


@export var jump_strength: float = 0.0
@export var move_speed: float = 50.0
@export var max_distance: float = 64 * 8
@export var toward_player: bool = true


@onready var player: CharacterBody2D = $"../../../../Player"


func enter() -> void:
	super()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	parent.state_walk()


func physics_update(_delta: float) -> void:
	var direction = player.global_position - parent.global_position
	if direction.length_squared() > max_distance * max_distance:
		transition.emit(self, "Idle")
		return
	var move_sign = 1.0
	if !toward_player:
		move_sign = -1
	parent.velocity = move_sign * direction.normalized() * Vector2(move_speed, jump_strength)
