extends Node


const TITLE_MUSIC: AudioStream = preload("uid://corj4jsms4hoo")
const GAME_MUSIC: Array[AudioStream] = [
	preload("uid://b8fhaptjrujdk"),
	preload("uid://bypmk30tjpq6g")
]
const CREDITS_MUSIC: AudioStream = preload("uid://uw7rmjf3h5yb")

enum MusicMode {
	MAIN_MENU,
	GAMEPLAY,
	CREDITS,
}

var _current_mode

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer


func _ready() -> void:
	_current_mode = MusicMode.MAIN_MENU
	_set_audio_stream()
	_play_music()
	
	audio_stream_player.finished.connect(_on_music_stop)
	timer.timeout.connect(_on_timer_timeout)


func set_music_mode(mode: MusicMode) -> void:
	if _current_mode == mode: return
	
	_current_mode = mode
	audio_stream_player.stop()
	_set_audio_stream()
	_play_music()


func set_music_mode_with_delay(mode: MusicMode, delay: float = 0.0) -> void:
	if _current_mode == mode: return
	
	_current_mode = mode
	audio_stream_player.stop()
	_set_audio_stream()
	await  get_tree().create_timer(delay).timeout
	if audio_stream_player.playing:
		return
	_play_music()


func _set_audio_stream() -> void:
	var stream: AudioStream
	if _current_mode == MusicMode.MAIN_MENU:
		stream = TITLE_MUSIC
	elif _current_mode == MusicMode.GAMEPLAY:
		var index = randi_range(0, GAME_MUSIC.size() - 1)
		stream = GAME_MUSIC[index]
	elif _current_mode == MusicMode.CREDITS:
		stream = CREDITS_MUSIC
	
	audio_stream_player.stream = stream


func _set_timer() -> void:
	var min_time: float
	var max_time: float
	
	if _current_mode == MusicMode.MAIN_MENU:
		min_time = 30.0
		max_time = 60.0
	elif _current_mode == MusicMode.GAMEPLAY:
		min_time = 45.0
		max_time = 120.0
	elif _current_mode == MusicMode.CREDITS:
		return
	
	var random_time := randf_range(min_time, max_time)
	timer.wait_time = random_time
	timer.start()


func _play_music() -> void:
	audio_stream_player.play()


func _on_music_stop() -> void:
	_set_timer()


func _on_timer_timeout() -> void:
	_set_audio_stream()
	_play_music()
