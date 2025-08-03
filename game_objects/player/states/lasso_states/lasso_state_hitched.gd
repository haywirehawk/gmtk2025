extends State

var hitch_component_scene = preload("uid://gwt1vja6sy86")
var hitch_component: LassoHitchComponent


func enter() -> void:
	parent.hitch_lasso()
	hitch_component = hitch_component_scene.instantiate()
	hitch_component.global_position = parent.target
	hitch_component.origin_point = parent.global_position
	hitch_component.sprite_texture = parent.hitched_texture
	hitch_component.show()
	get_tree().get_first_node_in_group("entities_layer").add_child(hitch_component)
	
	parent.player.set_can_climb(true)
	parent.player.audio_player.play_lasso_hitch()


func exit() -> void:
	hitch_component.queue_free()
	parent.reset_rope()
	parent.player.set_can_climb(false)


func update(delta: float) -> void:
	if parent.player.input_release_just_pressed:
		transition.emit(self, "idle")
		return
	parent.swing(delta)


func physics_update(_delta: float) -> void:
	pass
