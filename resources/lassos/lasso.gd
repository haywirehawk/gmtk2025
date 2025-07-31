class_name LassoResource
extends Resource

@export var id: String
@export var name: String
@export_multiline var description: String
@export var rope_texture: Texture2D
@export var hitched_texture: Texture2D
@export var rope_honda_frames: SpriteFrames
@export_range(20, 200, 10) var max_length: float = 80
@export_range(20, 200, 10) var rest_length: float = 80
@export_range(20, 200, 5) var throw_speed: float = 80
@export_range(5, 100, 5) var stiffness: float = 20
@export_range(0, 20, 2) var damping_factor: float = 2
