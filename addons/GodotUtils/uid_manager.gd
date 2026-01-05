extends RefCounted
class_name UIDManager
## 获取UID的语法糖的单例

## 从对象获取脚本路径
static func get_script_path(object: Object) -> StringName:
	var res: Resource = object.get_script()
	assert(res != null, "Object must have script!")
	return res.resource_path
	
## 从对象获取uid字符串
static func get_uid_from_object(object: Object) -> StringName:
	return ResourceUID.id_to_text(
		get_uid_value_from_object(object)
	)
	
## 从对象获取uid数字
static func get_uid_value_from_object(object: Object) -> int:
	return ResourceLoader.get_resource_uid(
		get_script_path(object)
	)
	
## 把uid数字转uid字符串
static func id_to_text(id: int) -> StringName:
	return ResourceUID.id_to_text(id)
	
