class_name GameManager
extends Node

const PLAYER_SCENE = preload("uid://bbs6thqicl6be")

@export var camera: GameCamera
@export var tornado: Tornado
@export var hud: HUD
@export var upgrade_manager: UpgradeManager
@export var spawn_location: Marker2D

var player: Player
var dust_particle_scene: PackedScene = preload("uid://c2wxaso1uvwb2")
var max_dust_particles: int = 15
var max_dust_particles_spawn: int = 5

var doom_clock: int = 0
var life: int = 3
var closing_rate: float = 25
var end_screen_path = "uid://cqp2efgxp1mmc"

var tween_in_time: float = 0.8
var tween_out_time: float = 0.6

@onready var doom_timer: Timer = %DoomTimer
@onready var dust_timer: Timer = %DustTimer
@onready var grace_period_timer: Timer = %GracePeriodTimer


func _ready() -> void:
	MusicManager.set_music_mode_with_delay(MusicManager.MusicMode.GAMEPLAY, 10.0)
	
	GameEvents.tornado_hit.connect(_on_tornado_hit)
	GameEvents.player_spawned.connect(_on_player_spawned)
	GameEvents.game_over.connect(_on_game_over)
	doom_timer.timeout.connect(_on_doom_timer_timeout)
	dust_timer.timeout.connect(_on_dust_timer_timeout)
	grace_period_timer.timeout.connect(_on_grace_period_timeout)
	
	spawn_player()
	
	add_dust()
	dust_timer.start()


func _process(_delta: float) -> void:
	if player:
		if player.check_out_of_bounds():
			player.queue_free()
			respawn_player()


func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn_location.global_position
	get_tree().get_first_node_in_group("entities_layer").add_child(player)
	camera.set_target(player, false)
	camera.shake(1.0)
	GameEvents.emit_player_spawned(player)


func respawn_player() -> void:
	life -= 1
	if life <= 0:
		end_game(false)
		return
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn_location.global_position
	player.lockout(true)
	player.scale = Vector2(3, 3)
	get_tree().get_first_node_in_group("entities_layer").add_child(player)
	tween_in(player)
	await get_tree().create_timer(tween_in_time).timeout
	camera.set_target(player, false)
	camera.shake(1.0)
	GameEvents.emit_player_spawned(player)
	set_grace_period()


func reset_doom() -> void:
	pass


## Stops timers before they timeout. No signals will be emitted.
func stop_timers() -> void:
	doom_timer.stop()
	dust_timer.stop()


func add_dust() -> void:
	var current_particles_count: int = get_tree().get_first_node_in_group("particles_layer").get_child_count()
	var room_for_more: int = max_dust_particles - current_particles_count
	var spawn_count: int = 0
	
	if room_for_more > 0:
		spawn_count = randi_range(0, room_for_more)
	
	if spawn_count > 0:
		var center_position := camera.global_position
		var spawn_node = get_tree().get_first_node_in_group("particles_layer")
		spawn_count = min(spawn_count, max_dust_particles_spawn)
		for i in spawn_count:
			var x = randf_range(-160, 160)
			var y = randf_range(-120, 50)
			var position = center_position + Vector2(x, y)
			var dust = dust_particle_scene.instantiate()
			dust.global_position = position
			spawn_node.add_child(dust)
	
	dust_timer.start()


func tween_out(node: Node2D) -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(node, "scale", Vector2(3, 3), tween_out_time).from(Vector2.ONE)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(node, "rotation", PI * 4, tween_out_time).from(0)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect(_on_tween_out_finished)


func tween_in(node: Node2D) -> void:
	var end_location := node.global_position
	var start_location := end_location + Vector2(0, -50)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(node, "scale", Vector2.ONE, tween_in_time).from(Vector2(3, 3))\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(node, "position", end_location, tween_in_time).from(start_location)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(node, "rotation", 0, tween_in_time).from(2 * PI)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect(_on_tween_in_finished)


func set_grace_period() -> void:
	tornado.stop_tornado()
	grace_period_timer.start()
	doom_timer.stop()


func end_game(victory: bool) -> void:
	GameEvents.emit_gameover(victory)


func _on_game_over(_success: bool) -> void:
	get_tree().change_scene_to_file(end_screen_path)


func _on_grace_period_timeout() -> void:
	tornado.start_tornado()
	doom_timer.start()


func _on_doom_timer_timeout() -> void:
	doom_clock += 1
	tornado.set_closing_speed(closing_rate * doom_clock)


func _on_dust_timer_timeout() -> void:
	add_dust()


func _on_tornado_hit() -> void:
	player.lockout(true)
	
	tween_out(player)


func _on_player_spawned(_player: Player) -> void:
	if tornado:
		tornado.setup(_player)


func _on_tween_out_finished() -> void:
	player.queue_free()
	camera.set_target(spawn_location)
	await get_tree().create_timer(1.0).timeout
	respawn_player()


func _on_tween_in_finished() -> void:
	player.lockout(false)
