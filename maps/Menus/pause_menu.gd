extends Node2D

func _process(delta: float) -> void:
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
	$Control/OptionsMenu.show()
	$Control/BackButton.show()
	$Control/VBoxContainer.hide()


func _on_main_menu_button_pressed() -> void:
	closePauseMenu()
	loadlevel("res://maps/Menus/MainMenu.tscn")


func _on_back_button_pressed() -> void:
	$Control/OptionsMenu.hide()
	$Control/BackButton.hide()
	$Control/VBoxContainer.show()

func loadlevel(LevelName):
	var new_scene = load(LevelName)
	get_tree().change_scene_to_packed(new_scene)

func openPauseMenu():
	$Control/VBoxContainer.show()
	$Control/BackgroundMask.show()
	
func closePauseMenu():
	get_tree().paused = false
	$Control/VBoxContainer.hide()
	$Control/BackButton.hide()
	$Control/OptionsMenu.hide()
	$Control/BackgroundMask.hide()
