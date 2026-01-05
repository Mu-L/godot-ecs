extends Node
class_name ECSAsyncSystem

enum {
	READ_ONLY = 0,
	READ_WRITE,
}

var _name: StringName
var _before_list: Array
var _after_list: Array

func name() -> StringName:
	return _name
	
func before(systems: Array) -> ECSAsyncSystem:
	_before_list = systems
	return self
	
func after(systems: Array) -> ECSAsyncSystem:
	_after_list = systems
	return self
	
func fetch_before_systems(querier: Callable) -> void:
	querier.call(_name, _before_list)
	
func fetch_after_systems(querier: Callable) -> void:
	querier.call(_name, _after_list)
	
func list_components() -> Dictionary[StringName, int]:
	return _list_components()
	
func view_components(_view: Dictionary) -> void:
	_view_components(_view)
	
# ==============================================================================
# override
func _list_components() -> Dictionary[StringName, int]:
	return {}
	
# override
func _view_components(_view: Dictionary) -> void:
	pass
	
# ==============================================================================
# private
func _init(name: StringName, parent: Node = null) -> void:
	_name = name
	if parent:
		parent.add_child(self)
	
