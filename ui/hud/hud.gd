class_name HUD
extends CanvasLayer

@export var inventory_manager: InventoryManager
@export var upgrade_manager: UpgradeManager
@export var inventory_item_scene: PackedScene

@onready var doom_status_container: HBoxContainer = %DoomStatusContainer
@onready var inventory_container: VBoxContainer = %InventoryContainer
@onready var equipment_container: EquipmentContainer = %EquipmentContainer


func _ready() -> void:
	GameEvents.player_inventory_changed.connect(_on_inventory_changed)
	upgrade_manager.lassos_updated.connect(_on_lassos_updated)
	
	update_inventory(inventory_manager.get_current_inventory())
	update_equipment()


func update_equipment() -> void:
	var equipment_number := upgrade_manager.get_collection_size()
	if equipment_number == 0:
		equipment_container.hide_all()
	elif equipment_number == 1:
		equipment_container.show_primary()
		equipment_container.set_selected_equipment(upgrade_manager.get_current_lasso())
	else:
		equipment_container.show_all()
		equipment_container.set_previous_equipment(upgrade_manager.get_previous_lasso(false))
		equipment_container.set_selected_equipment(upgrade_manager.get_current_lasso())
		equipment_container.set_next_equipment(upgrade_manager.get_next_lasso(false))


func _clear_container(container: Node):
	var container_children = container.get_children()
	for i in container_children.size():
			container_children[i].queue_free()


func update_inventory(current_inventory: Dictionary):
	_clear_container(inventory_container)
	
	for item in current_inventory:
		var inventory_item_instance = inventory_item_scene.instantiate()
		inventory_container.add_child(inventory_item_instance)
		inventory_item_instance.update_item_display(current_inventory[item]["resource"], current_inventory)


func _on_inventory_changed(current_inventory):
	update_inventory(current_inventory)


func _on_lassos_updated():
	update_equipment()
