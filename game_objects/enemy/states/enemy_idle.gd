extends State

@export var minimum_idle: float = 1
@export var maximum_idle: float = 8


var idle_time: float


func randomize_idle_time():
	idle_time = randf_range(minimum_idle, maximum_idle)


func enter() -> void:
	super()
	randomize_idle_time()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	if idle_time > 0:
		idle_time -= _delta
		parent.state_idle()
	else:
		transition.emit(self, "Walk")


func physics_update(_delta: float) -> void:
	pass
