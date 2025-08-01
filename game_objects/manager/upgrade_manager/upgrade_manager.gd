class_name UpgradeManager
extends Node

signal new_lasso_acquired
signal lasso_equipped(lasso: LassoResource)

@export var starting_lasso: LassoResource

var player: Player
var _current_lasso_collection: Array[LassoResource]
var _current_index: int


func _ready() -> void:
	GameEvents.player_spawned.connect(_on_player_spawned)
	GameEvents.lasso_acquired.connect(_on_lasso_acquired)
	_add_lasso_to_collection(starting_lasso)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_lasso"):
		if player.try_change_lasso(get_next_lasso()):
			GameEvents.emit_lasso_equipped(get_current_lasso())
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("previous_lasso"):
		if player.try_change_lasso(get_previous_lasso()):
			GameEvents.emit_lasso_equipped(get_current_lasso())
		get_viewport().set_input_as_handled()


func get_current_lasso(try_index: int = -1) -> LassoResource:
	var index := try_index if try_index >= 0 and try_index < _current_lasso_collection.size() else _current_index
	var lasso := _current_lasso_collection[_current_index]
	print("Selected %s at index %d" % [lasso.name, _current_index])
	return lasso


func get_next_lasso() -> LassoResource:
	var max_index = _current_lasso_collection.size() - 1
	if _current_index == max_index:
		_current_index = 0
	else:
		_current_index += 1
	return get_current_lasso()


func get_previous_lasso() -> LassoResource:
	var max_index = _current_lasso_collection.size() - 1
	if _current_index == 0:
		_current_index = max_index
	else:
		_current_index -= 1
	return get_current_lasso()


func _on_player_spawned(active_player: Player) -> void:
	player = active_player


func _add_lasso_to_collection(new_upgrade: LassoResource) -> void:
	if _current_lasso_collection.has(new_upgrade): return
	
	_current_lasso_collection.append(new_upgrade)
	#var new_index := _current_lasso_collection.find(new_upgrade)
	#if player:
		#if player.try_change_lasso(get_current_lasso(new_index)):
			#print("success?")
			#_current_index = new_index


func _on_lasso_acquired(new_upgrade: LassoResource) -> void:
	_add_lasso_to_collection(new_upgrade)
	print("Found %s" % new_upgrade.name)
	new_lasso_acquired.emit()
