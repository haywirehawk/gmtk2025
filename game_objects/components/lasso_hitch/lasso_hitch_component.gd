class_name LassoHitchComponent
extends Sprite2D

var origin_point: Vector2
var sprite_texture: Texture2D
var shader: Shader
var particles: PackedScene


func _ready() -> void:
	if origin_point:
		rotation = get_angle_to(origin_point)
	if sprite_texture:
		texture = sprite_texture
	if shader:
		material = ShaderMaterial.new()
		material.shader = shader
	if particles:
		add_child(particles.instantiate())
