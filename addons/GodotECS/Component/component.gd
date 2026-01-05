extends Serializer
class_name ECSComponent

var _name: StringName = "unknown"
var _entity: ECSEntity
var _world: WeakRef

func name() -> StringName:
	return _name
	
func entity() -> ECSEntity:
	return _entity
	
func world() -> ECSWorld:
	return _world.get_ref() if _world else null
	
func remove_from_entity() -> void:
	entity().remove_component(_name)
	
func _set_world(world: ECSWorld) -> void:
	_world = weakref(world)
	
func _to_string() -> String:
	return "component:%s" % _name
	
# override
func _on_pack(ar: Archive) -> void:
	pass
	
# override
func _on_unpack(ar: Archive) -> void:
	pass
	
# override
func _on_convert(ar: Archive) -> void:
	pass
	
# override
func _on_test() -> void:
	pass
	
