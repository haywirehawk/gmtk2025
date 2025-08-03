extends Area2D

@export var active_sprite: Texture2D


func _ready() -> void:
	$ActiveSprite.texture = active_sprite
	$ActiveSprite.hide()
	
	area_entered.connect(_on_area_entered)


func activate() -> void:
	$CollisionShape2D.disabled = true
	$ActiveSprite.hide()
	GameEvents.emit_quest_updated()


func _on_area_entered(_other_area: Area2D) -> void:
	activate()
