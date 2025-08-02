extends CanvasLayer

var options_menu_scene: PackedScene =  preload("uid://dvhlk1kmxn4lj")

@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	closePauseMenu()
	
	UIAudioManager.register_buttons([
		resume_button,
		options_button,
		main_menu_button,
	])


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if get_tree().current_scene.name != "MainMenu":
			get_tree().paused = !get_tree().paused
			if get_tree().paused:
				openPauseMenu()
			else:
				closePauseMenu()


func _on_resume_button_pressed() -> void:
	closePauseMenu()


func _on_options_button_pressed() -> void:
	var options_menu := options_menu_scene.instantiate()
	add_child(options_menu)


func _on_main_menu_button_pressed() -> void:
	closePauseMenu()
	loadlevel("res://maps/Menus/MainMenu.tscn")


func loadlevel(LevelName):
	var new_scene = load(LevelName)
	get_tree().change_scene_to_packed(new_scene)


func openPauseMenu():
	show()
	
	
func closePauseMenu():
	get_tree().paused = false
	hide()
