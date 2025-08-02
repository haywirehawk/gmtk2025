extends CanvasLayer

@onready var close_button: Button = %CloseButton


func _ready() -> void:
	UIAudioManager.register_buttons([
		close_button,
	])
	MusicManager.set_music_mode(MusicManager.MusicMode.CREDITS)
	
	close_button.pressed.connect(_on_close_button_pressed)


func  _on_close_button_pressed() -> void:
	MusicManager.set_music_mode(MusicManager.MusicMode.MAIN_MENU)
	queue_free()
