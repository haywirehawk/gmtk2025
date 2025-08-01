class_name LassoResource
extends Resource

# Details
@export var id: String
@export var title: String
@export_multiline var description: String
# Assets
@export var rope_texture: Texture2D
@export var hitched_texture: Texture2D
@export var rope_honda_frames: SpriteFrames
@export var rope_slack_texture: Texture2D
@export var shader: Shader
@export var particles: PackedScene
# Stats
@export_range(20, 200, 10) var max_length: float = 80
@export_range(20, 200, 10) var rest_length: float = 80
@export_range(20, 200, 5) var throw_speed: float = 80
@export_range(0, 100, 5) var stiffness: float = 20
@export_range(0, 30, 2) var damping_factor: float = 2
