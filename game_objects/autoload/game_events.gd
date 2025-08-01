extends Node


signal player_inventory_changed(inventory: Dictionary)
signal player_inventory_add_to(item: InventoryObject, count: int)
signal enemy_died


func emit_player_inventory_changed(current_inventory: Dictionary):
	player_inventory_changed.emit(current_inventory)


func emit_player_inventory_add_to(item: InventoryObject, count: int):
	player_inventory_add_to.emit(item, count)


func emit_enemy_died() -> void:
	enemy_died.emit()
