extends State

var old_number: int

func enter() -> void:
	old_number = parent.lasso_honda_area.collision_layer
	parent.lasso_honda_area.collision_layer = 0


func exit() -> void:
	parent.lasso_honda_area.collision_layer = old_number


func update(_delta: float) -> void:
	parent.aim_lasso()
	if parent.player.input_lasso_just_pressed:
		transition.emit(self, "ready")
		return


func physics_update(_delta: float) -> void:
	pass
