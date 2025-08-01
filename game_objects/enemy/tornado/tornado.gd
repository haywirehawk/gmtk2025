extends CharacterBody2D


@export var speed: float = 10
@export var movement_damping: float = 5.0

@onready var movement_timer: Timer

var direction: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_timer = $MovementTimer
	movement_timer.timeout.connect(_update_direction)
	movement_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_velocity = speed * direction
	velocity.x = lerp(velocity.x, target_velocity, 1 - exp(-movement_damping * delta))
	move_and_slide()


func _update_direction() -> void:
	direction = randi_range(-1, 1)
