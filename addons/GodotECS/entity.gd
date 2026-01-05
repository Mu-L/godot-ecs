extends RefCounted
class_name ECSEntity

var _id: int
var _world: WeakRef

signal on_component_added(e: ECSEntity, c: ECSComponent)
signal on_component_removed(e: ECSEntity, c: ECSComponent)

func _init(id: int, world: ECSWorld) -> void:
	_id = id
	_world = weakref(world)
	
func destroy() -> void:
	if _id != 0:
		world().remove_entity(_id)
		_id = 0
	
func id() -> int:
	return _id
	
func world() -> ECSWorld:
	return _world.get_ref()
	
func valid() -> bool:
	return _id >= 1 and world().has_entity(_id)
	
func notify(event_name: StringName, value = null) -> void:
	if _id == 0:
		return
	world().notify(event_name, value)
	
func send(e: GameEvent) -> void:
	if _id == 0:
		return
	world().send(e)
	
func add_component(name: StringName, component := ECSComponent.new()) -> bool:
	return world().add_component(_id, name, component)
	
func remove_component(name: StringName) -> bool:
	return world().remove_component(_id, name)
	
func remove_all_components() -> bool:
	return world().remove_all_components(_id)
	
func get_component(name: StringName) -> ECSComponent:
	return world().get_component(_id, name)
	
func get_components() -> Array:
	return world().get_components(_id)
	
func has_component(name: StringName) -> bool:
	return world().has_component(_id, name)
	
func _to_string() -> String:
	return "entity:%d" % _id
	
