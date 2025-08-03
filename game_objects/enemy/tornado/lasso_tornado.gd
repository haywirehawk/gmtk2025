class_name BossTornado
extends Node2D


@export var speed: float = 10
@export var movement_damping: float = 0.5

@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var audio_player: AudioStreamPlayer2D = %AudioPlayer
@onready var audio_timer: Timer = $AudioTimer

var lock: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.successful_hit.connect(_tornado_hit)
	audio_timer.timeout.connect(_on_audio_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if lock: return
	follow_target(delta)


func stop() -> void:
	lock = true
	$HitboxComponent.queue_free()


func follow_target(delta: float) -> void:
	global_position.x = lerp(global_position.x, 0.0, 1 - exp(-movement_damping * delta))


func play_sounds() -> void:
	%AudioPlayer.play()


func _tornado_hit(_direction: Vector2) -> void:
	GameEvents.tornado_hit.emit()


func _on_audio_timer_timeout() -> void:
	play_sounds()
