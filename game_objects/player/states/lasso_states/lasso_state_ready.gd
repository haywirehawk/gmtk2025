extends State

var _max_strength: bool
var _current_strength_percent: float
#var _shader_tween: Tween
var _timer: SceneTreeTimer
var _duration: float = 0.5

@onready var _progress_bar: ProgressBar = %ThrowChargeProgressBar
#@onready var _progress_bar_material: ShaderMaterial = %ThrowChargeProgressBar.material


func enter() -> void:
	_reset_variables()
	animations.play("ready_lasso")
	_progress_bar.show()
	_progress_bar.value = 0.0
	_timer = get_tree().create_timer(_duration)
	_timer.timeout.connect(_timer_timeout)


func exit() -> void:
	_reset_variables()


func update(_delta: float) -> void:
	parent.aim_lasso()
	if not _max_strength:
		var percent := ((_duration - _timer.time_left) / _duration)
		_current_strength_percent = percent
		_progress_bar.value = percent
	else:
		_current_strength_percent = 1.2
	if parent.player.input_lasso_held:
		return
	else:
		parent.strength_percent = _current_strength_percent
		transition.emit(self, "throw")
		return


#func set_shader(value: float) -> void:
	#value = clampf(value, 0.0, 1.0)
	#_progress_bar_material.set_shader_parameter("shader_parameter/intensity", value)
	#_progress_bar_material.set_shader_parameter("shader_parameter/flash_color", Color.RED)
	#_progress_bar_material.shad
	#print("argument" + str(value))
	#print("parameter" + str(_progress_bar_material.get_shader_parameter("shader_parameter/intensity")))
	#
#
#
#func _play_ready_effects() -> void:
	#if _shader_tween and _shader_tween.is_valid():
		#_shader_tween.kill()
	#
	#_shader_tween = create_tween()
	#_shader_tween.tween_method(set_shader, 1.0, 0.0, 1)\
	#.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)


func _reset_variables() -> void:
	animations.stop()
	_max_strength = false
	_current_strength_percent = 0.0
	_progress_bar.hide()
	_progress_bar.value = 0.0
	_progress_bar.theme_type_variation = ""
	if _timer and _timer.timeout.has_connections():
		_timer.timeout.disconnect(_timer_timeout)


func _timer_timeout() -> void:
	_max_strength = true
	_progress_bar.value = 1.0
	_progress_bar.theme_type_variation = "MaxProgressBar"
	#_play_ready_effects()
