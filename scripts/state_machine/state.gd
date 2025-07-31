extends Node
class_name State

@warning_ignore("unused_signal")
signal transition(state: State, new_state_name: String)

## The [param String] name of the animation to play when entering this state.
@export var animation_name: String

# Holds a reference to the parent and animation player
# to avoid scene tree heirarchy assumptions.
var parent: Node2D: set = _set_parent
var animations: Node


func _set_parent(node: Node2D) -> void:
	parent = node
	return


func init():
	pass


## Called when entering this state, to set up before updates start. [br]
## Use [param super()] to use the base function (such as animations)
## in addition to extended class overrides.
func enter() -> void:
	if animations:
		animations.play(animation_name)


## Called when exiting this state.
func exit() -> void:
	pass


## Called every frame while this state is active.
func update(_delta: float) -> void:
	pass


## Called every physics frame while this state is active.
func physics_update(_delta: float) -> void:
	pass
