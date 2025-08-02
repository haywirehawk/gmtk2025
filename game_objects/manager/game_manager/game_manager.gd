class_name GameManager
extends Node

const PLAYER_SCENE = preload("uid://bbs6thqicl6be")

@export var camera: GameCamera
@export var tornado: Node
@export var hud: HUD
@export var upgrade_manager: UpgradeManager
@export var spawn_location: Marker2D

var player: Player
var dust_particle_scene: PackedScene = preload("uid://c2wxaso1uvwb2")
var max_dust_particles: int = 15
var max_dust_particles_spawn: int = 5

@onready var doom_start_timer: Timer = %DoomStartTimer
@onready var dust_timer: Timer = %DustTimer


func _ready() -> void:
	MusicManager.set_music_mode_with_delay(MusicManager.MusicMode.GAMEPLAY, 10.0)
	
	GameEvents.tornado_hit.connect(_on_tornado_hit)
	doom_start_timer.timeout.connect(_on_doom_timer_timeout)
	dust_timer.timeout.connect(_on_dust_timer_timeout)
	
	spawn_player()
	
	add_dust()
	dust_timer.start()


func _process(_delta: float) -> void:
	if player:
		if player.check_out_of_bounds():
			player.queue_free()
			spawn_player()


func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn_location.global_position
	get_tree().get_first_node_in_group("entities_layer").add_child(player)
	camera.set_target(player, false)
	camera.shake(1.0)
	GameEvents.emit_player_spawned(player)


func reset_doom() -> void:
	pass


## Stops timers before they timeout. No signals will be emitted.
func stop_timers() -> void:
	doom_start_timer.stop()
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


func _on_doom_timer_timeout() -> void:
	pass


func _on_dust_timer_timeout() -> void:
	add_dust()


func _on_tornado_hit() -> void:
	print("Tornado hit!")
