extends CanvasLayer

@onready var main_scene: PackedScene = preload("uid://cmy4xujejhlfw")
@onready var options_menu_scene: PackedScene =  preload("uid://dvhlk1kmxn4lj")
@onready var credits_scene: PackedScene = preload("uid://kdd14og66w30")

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	SaveData.get_settings_data().apply_all_from_data()
	
	UIAudioManager.register_buttons([
		play_button,
		options_button,
		credits_button,
		quit_button,
	])
	
	MusicManager.set_music_mode(MusicManager.MusicMode.MAIN_MENU)
	
	if OS.has_feature("web"):
		quit_button.hide()


func _on_play_button_pressed() -> void:
	loadlevel(main_scene)


func _on_options_button_pressed() -> void:
	var options_menu := options_menu_scene.instantiate()
	add_child(options_menu)


func _on_credits_button_pressed() -> void:
	var credits := credits_scene.instantiate()
	add_child(credits)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func loadlevel(level: PackedScene) -> void:
	get_tree().change_scene_to_packed(level)
