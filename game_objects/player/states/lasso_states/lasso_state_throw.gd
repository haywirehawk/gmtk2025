extends State

var target: Vector2
var current_position: Vector2
var max_distance: float
var old_raycast_target: Vector2
var old_honda_offset: Vector2
var lasso_honda: CharacterBody2D
var lasso_sprite: AnimatedSprite2D

func enter() -> void:
	old_raycast_target = parent.lasso_raycast.target_position
	target = parent.to_global(parent.lasso_raycast.target_position * parent.strength_percent)
	parent.lasso_raycast.target_position = Vector2.ZERO
	parent.lasso_raycast.force_raycast_update()
	
	
	lasso_honda = parent.lasso_honda_area
	lasso_sprite = parent.lasso_honda_sprite
	old_honda_offset = lasso_sprite.offset
	lasso_sprite.play("thrown")
	lasso_honda.show()
	parent.lasso_line.show()
	
	max_distance = parent.max_length
	current_position = lasso_honda.global_position
	get_tree().create_timer(2.0).timeout.connect(_timer_timeout)
	
	parent.player.audio_player.play_lasso_throw()
	
	#var direction = lasso_honda.global_position.direction_to(target).normalized()
	#lasso_honda.velocity = direction * parent.throw_speed


func exit() -> void:
	lasso_honda.hide()
	parent.lasso_honda_sprite.stop()
	lasso_honda.position = Vector2.ZERO
	parent.lasso_honda_sprite.offset = old_honda_offset
	parent.lasso_raycast.target_position = old_raycast_target
	parent.reset_rope()


func update(_delta: float) -> void:
	var delta = get_process_delta_time()
	lasso_honda.global_position = current_position.move_toward(target, parent.throw_speed * 2 * delta)
	lasso_sprite.offset = lerp(lasso_sprite.offset, Vector2(0, 0), 1- exp(-10 * delta))
	#lasso_honda.move_and_slide() # Some wonkiness with it being attached to the player
	current_position = lasso_honda.global_position
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


func _timer_timeout() -> void:
	transition.emit(self, "idle")
