extends RefCounted
class_name ObjectFactory
	
# =======================================================
# public
func register(class_type: Resource, init_params := []) -> void:
	_register(class_type, init_params)
	
func object_to_uid(object: Object) -> int:
	return _object_to_uid(object)
	
func uid_to_object(uid: int) -> Object:
	return _uid_to_object(uid)
	
# =======================================================
# private
func _register(class_type: Resource, init_params: Array) -> void:
	var uid := _get_class_uid(class_type)
	_inner_type[uid] = class_type
	_inner_creater[uid] = _get_class_creater(uid, init_params)
	
func _object_to_uid(object: Object) -> int:
	var uid: int = 0
	var path: String = object.get_script().resource_path
	if path.is_empty():
		# inner class
		return _get_class_uid(object.get_script())
	# global class
	return ResourceLoader.get_resource_uid(path)
	
func _uid_to_object(uid: int) -> Object:
	var creater := _inner_creater[uid]
	if creater == null:
		# global class
		var path := ResourceUID.id_to_text(uid)
		# uid is inner class if failed, must register inner class.
		assert(ResourceLoader.exists(path), "uid<%s> is not exists!" % path)
		return load(path).new()
	# return inner class instance
	return creater.call()
	
func _get_class_uid(type: Resource) -> int:
	var path := "uid://%s" % type
	return ResourceUID.create_id_for_path(path)
	
func _get_class_creater(uid: int, init_params: Array) -> Callable:
	match init_params.size():
		0:
			return (func(inner_type: Dictionary[int, Resource], uid: int) -> Object:
				return inner_type[uid].new()
			).bind(_inner_type, uid)
		1:
			return (func(inner_type: Dictionary[int, Resource], uid: int, v1: Variant) -> Object:
				return inner_type[uid].new(v1)
			).bind(_inner_type, uid, init_params[0])
		2:
			return (func(inner_type: Dictionary[int, Resource], uid: int, v1: Variant, v2: Variant) -> Object:
				return inner_type[uid].new(v1, v2)
			).bind(_inner_type, uid, init_params[0], init_params[1])
		3:
			return (func(inner_type: Dictionary[int, Resource], uid: int, v1: Variant, v2: Variant, v3: Variant) -> Object:
				return inner_type[uid].new(v1, v2, v3)
			).bind(_inner_type, uid, init_params[0], init_params[1], init_params[2])
		4:
			return (func(inner_type: Dictionary[int, Resource], uid: int, v1: Variant, v2: Variant, v3: Variant, v4: Variant) -> Object:
				return inner_type[uid].new(v1, v2, v3, v4)
			).bind(_inner_type, uid, init_params[0], init_params[1], init_params[2], init_params[3])
		5:
			return (func(inner_type: Dictionary[int, Resource], uid: int, v1: Variant, v2: Variant, v3: Variant, v4: Variant, v5: Variant) -> Object:
				return inner_type[uid].new(v1, v2, v3, v4, v5)
			).bind(_inner_type, uid, init_params[0], init_params[1], init_params[2], init_params[3], init_params[4])
	return Callable()
	
# =======================================================
# members
var _inner_type: Dictionary[int, Resource]
var _inner_creater: Dictionary[int, Callable]
	
