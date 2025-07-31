extends State

var target: Vector2
var current_position: Vector2
var max_distance: float
var old_raycast_target: Vector2
var old_honda_offset: Vector2

func enter() -> void:
	print(parent.strength_percent)
	
	old_raycast_target = parent.lasso_raycast.target_position
	target = parent.to_global(parent.lasso_raycast.target_position * parent.strength_percent)
	parent.lasso_raycast.target_position = Vector2.ZERO
	parent.lasso_raycast.force_raycast_update()
	
	old_honda_offset = parent.lasso_honda.offset
	parent.lasso_honda.play("thrown")
	parent.lasso_honda.show()
	parent.lasso_line.show()
	
	max_distance = parent.max_length
	current_position = parent.lasso_honda.global_position
	get_tree().create_timer(2.0).timeout.connect(_timer_timeout)


func exit() -> void:
	parent.lasso_honda.hide()
	parent.lasso_honda.stop()
	parent.lasso_honda.position = Vector2.ZERO
	parent.lasso_honda.offset = old_honda_offset
	parent.lasso_raycast.target_position = old_raycast_target
	parent.reset_rope()


func update(_delta: float) -> void:
	var delta = get_process_delta_time()
	parent.lasso_honda.global_position = current_position.move_toward(target, parent.throw_speed * 4 * delta)
	parent.lasso_honda.offset = lerp(parent.lasso_honda.offset, Vector2(8, 0), 1- exp(-10 * delta))
	current_position = parent.lasso_honda.global_position
	var current_player_distance = parent.global_position.distance_to(current_position)
	parent.lasso_raycast.target_position = Vector2.RIGHT * current_player_distance
	
	if parent.lasso_raycast.is_colliding():
		parent.target = current_position
		transition.emit(self, "hitched")
		return
	
	var current_honda_distance := current_position.distance_to(target)
	if current_player_distance > max_distance or current_honda_distance < .01:
		parent.release_lasso()
		transition.emit(self, "idle")
		return
	
	parent.update_rope(0.0, current_position)


func physics_update(_delta: float) -> void:
	pass


func _timer_timeout() -> void:
	transition.emit(self, "idle")
