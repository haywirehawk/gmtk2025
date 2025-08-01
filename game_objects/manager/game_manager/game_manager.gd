class_name GameManager
extends Node

const PLAYER_SCENE = preload("uid://bbs6thqicl6be")

@export var camera: GameCamera
@export var tornado: Node
@export var hud: HUD
@export var upgrade_manager: UpgradeManager
@export var spawn_location: Marker2D

var player: Player

@onready var doom_start_timer: Timer = %DoomStartTimer


func _ready() -> void:
	hud.upgrade_manager = upgrade_manager
	
	spawn_player()


func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn_location.global_position
	get_tree().get_first_node_in_group("entities_layer").add_child(player)
	camera.assign_target(player)
	GameEvents.emit_player_spawned(player)


func reset_doom() -> void:
	pass


#func filler() -> void:
	#pass
#
#
#func filler() -> void:
	#pass
