extends Node2D

@export var upgrade_scene: PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var upgrade_location: Node2D = $UpgradeLocation


func _ready() -> void:
	if upgrade_scene:
		var upgrade = upgrade_scene.instantiate()
		upgrade_location.add_child(upgrade)
		upgrade.collected.connect(_on_collected)


func _on_collected() -> void:
	animation_player.stop()
