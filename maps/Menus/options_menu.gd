extends Node2D


func _ready() -> void:
	$VBoxContainer/HBoxContainer/MasterVolSlider.value = OptionsManager.MasterVolume
	$VBoxContainer/HBoxContainer2/MusicVolSlider.value = OptionsManager.MusicVolume
	$VBoxContainer/HBoxContainer3/FullscreenModeSelect.select(OptionsManager.ScreenMode)

func _on_master_vol_slider_value_changed(value: float) -> void:
	OptionsManager.ChangeMasterVolume(value)


func _on_music_vol_slider_value_changed(value: float) -> void:
	OptionsManager.ChangeMusicVolume(value)

func _on_sfx_vol_slider_value_changed(value: float) -> void:
	OptionsManager.ChangeSFXVolume(value)

func _on_fullscreen_mode_select_item_selected(index: int) -> void:
	OptionsManager.ChangeScreenMode(index)
