extends Node2D

@export var startingLevelName = "res://maps/test1/test_map_1.tscn"

func _on_play_button_pressed() -> void:
	loadlevel(startingLevelName)


func _on_options_button_pressed() -> void:
	HideMainMenuButtons()
	$Control/OptionsMenu.show()

func _on_credits_button_pressed() -> void:
	HideMainMenuButtons()


func _on_quit_button_pressed() -> void:
	get_tree().quit()



func loadlevel(LevelName):
	var new_scene = load(LevelName)
	get_tree().change_scene_to_packed(new_scene)

func HideMainMenuButtons():
	$Control/VBoxContainer.hide()
	$Control/BackButton.show()
	$Control/RichTextLabel.hide()


func _on_back_button_pressed() -> void:
	$Control/VBoxContainer.show()
	$Control/BackButton.hide()
	$Control/RichTextLabel.show()
	$Control/OptionsMenu.hide()
