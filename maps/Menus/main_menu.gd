extends CanvasLayer

@export var startingLevelName = "res://maps/test1/test_map_1.tscn"

func _on_play_button_pressed() -> void:
	loadlevel(startingLevelName)


func _on_options_button_pressed() -> void:
	HideMainMenuButtons()
	PauseMenu.get_node("Control/OptionsMenu").show()

func _on_credits_button_pressed() -> void:
	HideMainMenuButtons()


func _on_quit_button_pressed() -> void:
	get_tree().quit()



func loadlevel(LevelName):
	var new_scene = load(LevelName)
	get_tree().change_scene_to_packed(new_scene)

func HideMainMenuButtons():
	$VBoxContainer.hide()
	$BackButton.show()
	$RichTextLabel.hide()


func _on_back_button_pressed() -> void:
	$VBoxContainer.show()
	$BackButton.hide()
	$RichTextLabel.show()
	PauseMenu.get_node("Control/OptionsMenu").hide()
