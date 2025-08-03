extends CanvasLayer

@export var menu_scene: PackedScene

var current_scene: PackedScene
var title_defeat = "Thrown for a Loop"
var subtitle_defeat = "Tornado claims anotheR"

@onready var title_label: Label = %TitleLabel
@onready var subtitle_label: Label = %SubtitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var menu_button: Button = %MenuButton
@onready var quit_button: Button = %QuitButton
@onready var victory_layer: TileMapLayer = %VictoryLayer
@onready var victory_layer_2: TileMapLayer = %VictoryLayer2
@onready var defeat_layer: TileMapLayer = %DefeatLayer
@onready var defeat_layer_2: TileMapLayer = %DefeatLayer2
@onready var world_fire_particles: Node2D = %WorldFireParticles


func _ready() -> void:
	get_tree().paused = true
	menu_button.pressed.connect(on_menu_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	UIAudioManager.register_buttons([
		menu_button,
		quit_button,
	])
	
	if OS.has_feature("web"):
		quit_button.hide()
	
	if GameEvents.check_victory():
		MusicManager.set_music_mode(MusicManager.MusicMode.MAIN_MENU)
	else:
		set_defeat()


func set_defeat():
	title_label.text = title_defeat
	subtitle_label.text = subtitle_defeat
	victory_layer.hide()
	victory_layer_2.hide()
	world_fire_particles.queue_free()
	defeat_layer.show()
	defeat_layer_2.show()
	
	MusicManager.set_music_mode(MusicManager.MusicMode.CREDITS)


func on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(menu_scene)


func on_quit_button_pressed():
	get_tree().quit()
