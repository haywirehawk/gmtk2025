extends Node2D


var quests_done: int = 0
@export var altar1: Area2D
@export var altar2: Area2D
@export var altar3: Area2D
@export var altar4: Area2D


func _ready() -> void:
	GameEvents.quest_updated.connect(_on_quest_updated)
	
	altar1.area_entered.connect(_on_area_entered1)
	altar2.area_entered.connect(_on_area_entered2)
	altar3.area_entered.connect(_on_area_entered3)
	altar4.area_entered.connect(_on_area_entered4)



func _on_quest_updated() -> void:
	quests_done += 1
	if quests_done >= 4:
		GameEvents.emit_quest_completed()


func _on_area_entered1(_other_area: Area2D) -> void:
	print("Entered")
	altar1.activate()


func _on_area_entered2(_other_area: Area2D) -> void:
	print("Entered")
	altar2.activate()


func _on_area_entered3(_other_area: Area2D) -> void:
	print("Entered")
	altar2.activate()


func _on_area_entered4(_other_area: Area2D) -> void:
	print("Entered")
	altar2.activate()
