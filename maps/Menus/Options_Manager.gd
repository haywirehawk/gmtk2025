extends Node

var MasterVolume = 1.0
var MusicVolume = 1.0
var SFXVolume = 1.0
var ScreenMode = 1

func ChangeMasterVolume(vol: float):
	MasterVolume = vol
	var db = lerp(-80, 0, MasterVolume)  # Map 0–1 to -80dB–0dB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)


func ChangeMusicVolume(vol: float):
	MusicVolume = vol
	var db = lerp(-80, 0, MusicVolume)  # Map 0–1 to -80dB–0dB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)


func ChangeSFXVolume(vol: float):
	SFXVolume = vol
	var db = lerp(-80, 0, SFXVolume)  # Map 0–1 to -80dB–0dB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)
	
	
func ChangeScreenMode(mode: int):
	ScreenMode = mode
	match ScreenMode:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
