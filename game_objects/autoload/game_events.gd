extends Node

signal player_spawned(player: Player)
signal lasso_acquired(lasso: LassoResource)
signal lasso_equipped(lasso: LassoResource)
signal player_inventory_changed(inventory: Dictionary)
signal player_inventory_add_to(item: InventoryObject, count: int)
signal enemy_died
signal tornado_hit()


func emit_player_spawned(player: Player) -> void:
	player_spawned.emit(player)


func emit_lasso_acquired(lasso: LassoResource) -> void:
	lasso_acquired.emit(lasso)


func emit_lasso_equipped(lasso: LassoResource) -> void:
	lasso_equipped.emit(lasso)


func emit_player_inventory_changed(current_inventory: Dictionary):
	player_inventory_changed.emit(current_inventory)


func emit_player_inventory_add_to(item: InventoryObject, count: int):
	player_inventory_add_to.emit(item, count)


func emit_enemy_died() -> void:
	enemy_died.emit()


func emit_tornado_hit() -> void:
	tornado_hit.emit()
