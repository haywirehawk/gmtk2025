class_name GrabbableComponent
extends Node2D


## Takes a boolean that is true for disabled and false for enabled.
## Sets the area2d responsible for grabbable collisions to that state.
func grabbable_area_disabled(disabled: bool) -> void:
	$Area2D/CollisionShape2D.disabled = disabled
