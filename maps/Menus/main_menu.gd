extends CanvasLayer

var dust_particle_scene: PackedScene = preload("uid://b25teamrjh2wt")
var max_dust_particles: int = 15
var max_dust_particles_spawn: int = 5

@onready var main_scene: PackedScene = preload("uid://cmy4xujejhlfw")
@onready var options_menu_scene: PackedScene =  preload("uid://dvhlk1kmxn4lj")
@onready var credits_scene: PackedScene = preload("uid://kdd14og66w30")

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton

@onready var dust_timer: Timer = $DustTimer


func _ready() -> void:
	SaveData.get_settings_data().apply_all_from_data()
	
	UIAudioManager.register_buttons([
		play_button,
		options_button,
		credits_button,
		quit_button,
	])
	
	MusicManager.set_music_mode(MusicManager.MusicMode.MAIN_MENU)
	
	dust_timer.timeout.connect(_on_dust_timer_timeout)
	add_dust()
	
	if OS.has_feature("web"):
		quit_button.hide()


func add_dust() -> void:
	var current_particles_count: int = get_tree().get_first_node_in_group("particles_layer").get_child_count()
	var room_for_more: int = max_dust_particles - current_particles_count
	var spawn_count: int = 0
	
	if room_for_more > 0:
		spawn_count = randi_range(0, room_for_more)
	
	if spawn_count > 0:
		
		var spawn_node = get_tree().get_first_node_in_group("particles_layer")
		spawn_count = min(spawn_count, max_dust_particles_spawn)
		for i in spawn_count:
			var x = randf_range(0, 640)
			var y = randf_range(0, 360)
			var position = Vector2(x, y)
			var dust = dust_particle_scene.instantiate()
			dust.global_position = position
			spawn_node.add_child(dust)
	
	dust_timer.start()


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


func _on_dust_timer_timeout() -> void:
	add_dust()
