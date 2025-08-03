extends Node2D

var quests_done: int = 0
@export var altar1: Area2D
@export var altar2: Area2D
@export var altar3: Area2D
@export var altar4: Area2D


@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	GameEvents.quest_updated.connect(_on_quest_updated)
	GameEvents.lasso_acquired.connect(_on_lasso_acquired)
	area_2d.area_entered.connect(_on_area_entered)


func _on_quest_updated() -> void:
	quests_done += 1


func check_quest_over() -> void:
	if quests_done >= 4:
		GameEvents.emit_quest_completed()


func _on_lasso_acquired(lasso: LassoResource) -> void:
	if lasso.id == "basic":
		altar1.activate()
	if lasso.id == "rubber":
		altar2.activate()
	if lasso.id == "fire":
		altar3.activate()
	if lasso.id == "ghost":
		altar4.activate()


func _on_area_entered(other_area: Area2D) -> void:
	check_quest_over()
