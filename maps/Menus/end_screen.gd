extends CanvasLayer

@export var menu_scene: PackedScene

var current_scene: PackedScene
var title_defeat = "You win!!!"
var description_defeat = "Now ride off into the sunset cowboy!."

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var restart_button: Button = %RestartButton
@onready var menu_button: Button = %MenuButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%MenuButton.pressed.connect(on_menu_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	title_label.text = title_defeat
	description_label.text = description_defeat


func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(menu_scene)


func on_quit_button_pressed():
	get_tree().quit()
