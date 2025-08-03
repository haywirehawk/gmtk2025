class_name PlayerAudioPlayer
extends AudioStreamPlayer2D

@export var player_jump_sound: AudioStream
@export var lasso_acquired_sound: AudioStream
@export var lasso_hitch_sound: AudioStream
@export var lasso_throw_sound: AudioStream


func play_jump() -> void:
	_set_and_play(player_jump_sound)


func play_lasso_acquired() -> void:
	_set_and_play(lasso_acquired_sound)


func play_lasso_hitch() -> void:
	_set_and_play(lasso_hitch_sound, 0.05)


func play_lasso_throw() -> void:
	_set_and_play(lasso_throw_sound, 0.05)


func _set_and_play(new_stream: AudioStream, value: float = 0.0) -> void:
	stop()
	stream = new_stream
	play(value)
