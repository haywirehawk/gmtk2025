extends Node
class_name StateMachine

## Starting state for this [param StateMachine]
@export var initial_state: State
## Allow gravity to affect this entity
@export var gravity: bool = true

var current_state: State
var states: Dictionary = {}


## Initializes all the states included as children to this node. [br]
## Requires a reference to the [Node2D], and an optional [AnimatedSprite2D] or [AnimationPlayer].
func setup(parent: Node2D, animation_node: Node = null) -> void:
	var animations: Node = null
	if animation_node is AnimatedSprite2D || animation_node is AnimationPlayer:
		animations = animation_node
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(_on_child_transition)
			child.parent = parent
			if animations:
				child.animations = animations
			if !gravity:
				child.gravity = 0
			child.init()
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


# Forward the process function to the active state
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


# Forward the physics process function to the active state
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


# Handle exiting previous state and entering next state based on owner node's calls.
func change_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state


# Handle exiting previous state and entering next state based on child node's logic.
func _on_child_transition(state: State, new_state_name: String):
	# Safety check: Only continue if the signal came from current scene
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
