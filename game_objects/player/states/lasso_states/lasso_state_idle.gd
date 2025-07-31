extends State


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	parent.aim_lasso()
	if parent.player.input_lasso_just_pressed:
		transition.emit(self, "ready")
		return


func physics_update(_delta: float) -> void:
	pass
