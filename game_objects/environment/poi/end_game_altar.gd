extends Area2D

@export var active_sprite: Texture2D
@export var rope_sprite: Texture2D
@export var lasso_id: String

func _ready() -> void:
	$ActiveSprite.texture = active_sprite
	$ActiveSprite.hide()
	$ropeSprite.texture = rope_sprite
	#area_entered.connect(_on_area_entered)


func activate() -> void:
	print("activate")
	$ActiveSprite.show()
	GameEvents.emit_quest_updated()


func _on_area_entered(_other_area: Area2D) -> void:
	print("Entered")
	activate()
