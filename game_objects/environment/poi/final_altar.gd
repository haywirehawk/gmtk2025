extends Node2D


var quests_done: int = 0


func _ready() -> void:
	GameEvents.quest_updated.connect(_on_quest_updated)


func _on_quest_updated() -> void:
	quests_done += 1
	if quests_done >= 4:
		GameEvents.emit_quest_completed()
