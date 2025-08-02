extends Node

signal transition_halfway


func load_level(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)


func transition_to_scene(scene: PackedScene) -> void:
	play_transition_in()
	await transition_halfway
	load_level(scene)
	play_transition_out()


func play_transition_in() -> void:
	pass


func play_transition_out() -> void:
	pass
