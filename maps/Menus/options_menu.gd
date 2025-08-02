extends CanvasLayer

var settings_data: SettingsData

@onready var master_vol_slider: HSlider = %MasterVolSlider
@onready var music_vol_slider: HSlider = %MusicVolSlider
@onready var sfx_vol_slider: HSlider = %SFXVolSlider
@onready var fullscreen_mode_select: OptionButton = %FullscreenModeSelect

@onready var confirm_button: Button = %ConfirmButton
@onready var cancel_button: Button = %CancelButton
@onready var default_button: Button = %DefaultButton


func _ready() -> void:
	update_display()
	settings_data = SaveData.get_settings_data()
	
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)
	default_button.pressed.connect(_on_default_button_pressed)
	
	UIAudioManager.register_buttons([
		default_button,
		confirm_button,
		cancel_button
	])


func update_display() -> void:
	master_vol_slider.value = get_bus_volume("Master")
	sfx_vol_slider.value = get_bus_volume("SFX")
	music_vol_slider.value = get_bus_volume("Music")
	var index = fullscreen_mode_select.get_item_index(DisplayServer.window_get_mode())
	fullscreen_mode_select.selected = index


func get_bus_volume(bus_name: String) -> float:
	var index := AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_linear(index)


func change_bus_volume(bus_name: String, linear_change: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	var current_volume := get_bus_volume(bus_name)
	AudioServer.set_bus_volume_linear(index, clamp(current_volume + linear_change, 0, 1))
	
	update_display()


func set_bus_volume(bus_name: String, value: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_linear(index, clamp(value, 0, 1))
	
	update_display()


func _on_master_vol_slider_value_changed(value: float) -> void:
	set_bus_volume("Master", value)


func _on_music_vol_slider_value_changed(value: float) -> void:
	set_bus_volume("Music", value)


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	set_bus_volume("SFX", value)


func _on_fullscreen_mode_select_item_selected(index: int) -> void:
	var id := fullscreen_mode_select.get_item_id(index)
	DisplayServer.window_set_mode(id)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func _on_confirm_button_pressed() -> void:
	settings_data.set_data_from_current_state()
	SaveData.set_settings_data(settings_data)
	SaveData.save_settings()
	queue_free()


func _on_cancel_button_pressed() -> void:
	settings_data.apply_all_from_data()
	queue_free()


func _on_default_button_pressed() -> void:
	SaveData.DEFAULT_SETTINGS.apply_all_from_data()
	update_display()
