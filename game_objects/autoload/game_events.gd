extends Node


signal player_inventory_add_to(item: InventoryObject, count: int)


func emit_player_inventory_add_to(item: InventoryObject, count: int):
	player_inventory_add_to.emit(item, count)	
