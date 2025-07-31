extends Area2D
class_name HurtboxComponent
## Component used for applying damage to a [HealthComponent] when colliding with a HitboxComponent
## Requires a HealthComponent in the scene

## [param direction] is the direction to the hitbox causing damage.
signal hurtbox_triggered(direction: Vector2)

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(on_area_entered)
	if health_component == null:
		printerr(owner.name + "'s HurtboxComponent is missing a connected HealthComponent")


func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent:
		return
	var hitbox_component = other_area as HitboxComponent
	#print(owner.name + " hurt by " + other_area.owner.name + " for " + str(hitbox_component.damage))
	health_component.damage(hitbox_component.damage)
	
	var direction = hitbox_component.global_position - self.global_position
	hitbox_component.hit(direction)
	hurtbox_triggered.emit(direction)
