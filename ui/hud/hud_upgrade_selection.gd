class_name EquipmentContainer
extends HBoxContainer

@onready var previous_container: AspectRatioContainer = %PreviousContainer
@onready var current_container: AspectRatioContainer = %CurrentContainer
@onready var next_container: AspectRatioContainer = %NextContainer

@onready var previous_texture: TextureRect = %PreviousTexture
@onready var current_texture: TextureRect = %CurrentTexture
@onready var next_texture: TextureRect = %NextTexture


func hide_all() -> void:
	previous_container.hide()
	current_container.hide()
	next_container.hide()


func show_all() -> void:
	previous_container.show()
	current_container.show()
	next_container.show()


func show_primary() -> void:
	previous_container.hide()
	current_container.show()
	next_container.hide()


func set_selected_equipment(lasso: LassoResource) -> void:
	current_texture.texture = lasso.hitched_texture


func set_next_equipment(lasso: LassoResource) -> void:
	next_texture.texture = lasso.hitched_texture


func set_previous_equipment(lasso: LassoResource) -> void:
	previous_texture.texture = lasso.hitched_texture
