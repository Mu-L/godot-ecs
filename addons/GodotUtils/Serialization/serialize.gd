extends RefCounted
class_name Serializer

const Archive = preload("archive.gd")
const InputArchive = preload("input_archive.gd")
const OutputArchive = preload("output_archive.gd")
const InOutArchive = preload("inout_archive.gd")

func pack(ar: Archive) -> void:
	_on_pack(ar)
	
func unpack(ar: Archive) -> void:
	_on_unpack(ar)
	
func convert(ar: Archive) -> void:
	_on_convert(ar)
	
func test() -> void:
	_on_test()
	
## Serialize the target object
static func serialize(ar: Archive, name: StringName, target: Serializer) -> void:
	var temp_data := {
		"__uid__": UIDManager.get_uid_value_from_object(target),
	}
	target.pack(OutputArchive.new(temp_data))
	ar.set_var(name, temp_data)
	
## Deserialize object from name
static func deserialize(ar: Archive, name: StringName) -> Serializer:
	var temp_data: Dictionary = ar.get_var(name, {})
	if not temp_data.has("__uid__"):
		return null
	var uid: int = temp_data["__uid__"]
	var target: Serializer = load(UIDManager.id_to_text(uid)).new()
	target.unpack(InputArchive.new(temp_data))
	return target
	
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
	
