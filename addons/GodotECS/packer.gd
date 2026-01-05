extends DataPacker
class_name ECSWorldPacker

# ==============================================================================
# override
func _pack() -> DataPack:
	var dict := {
		"version": _w.VERSION,
	}
	var pack := DataPack.new(dict)
	_pack_entities(dict)
	return pack
	
# override
func _unpack(pack: DataPack) -> bool:
	return _unpack_entities(pack.data())
	
# ==============================================================================
# private
var _w: ECSWorld
var _filter: Array[StringName]
	
func _init(w: ECSWorld, filter: Array[StringName] = []) -> void:
	_w = w
	_filter = filter
	
func _pack_entities(dict: Dictionary) -> void:
	var entity_data := {}
	var class_list: Array[StringName]
	var uid_list: Array[int]
	
	# 全量保存
	if _filter.is_empty():
		for eid: int in _w.get_entity_keys():
			var e := _w.get_entity(eid)
			var entity_dict := {
				"components": {},
			}
			_pack_components(e, entity_dict["components"], class_list, uid_list)
			entity_data[e.id()] = entity_dict
	# 筛选保存
	else:
		for views: Dictionary in _w.multi_view(_filter):
			var e: ECSEntity = views.entity
			var entity_dict := {
				"components": {},
			}
			_pack_components(e, entity_dict["components"], class_list, uid_list)
			entity_data[e.id()] = entity_dict
	
	dict["entities"] = entity_data
	dict["uid_list"] = uid_list
	dict["last_entity_id"] = _w._entity_id
	
func _pack_components(e: ECSEntity, dict: Dictionary, class_list: Array[StringName], uid_list: Array[int]) -> void:
	for c: ECSComponent in e.get_components():
		var c_dict := {}
		var output := Serializer.OutputArchive.new(c_dict)
		c.pack(output)
		dict[c.name()] = c_dict
		
		var resource_path := UIDManager.get_script_path(c)
		var pos = class_list.find(resource_path)
		if pos == -1:
			class_list.append(resource_path)
			uid_list.append(UIDManager.get_uid_value_from_object(c))
			pos = class_list.size() - 1
		c_dict["_class_index"] = pos
	
func _unpack_entities(dict: Dictionary) -> bool:
	# verify version
	if not dict.has("version") or not _valid_version(dict["version"]):
		return false
	
	# verify keys
	var required_keys := ["entities", "uid_list", "last_entity_id"]
	for key: StringName in required_keys:
		if not dict.has(key):
			return false
	
	_w.remove_all_entities()
	
	var uid_list: Array[int] = dict.uid_list
	
	# restore entities
	for eid: int in dict.entities:
		var entity_dict: Dictionary = dict.entities[eid]
		var e = _w._create_entity(eid)
	
	# restore components
	for eid: int in dict.entities:
		var entity_dict: Dictionary = dict.entities[eid]
		_unpack_components(_w.get_entity(eid), entity_dict["components"], uid_list)
	
	# restore components data
	for eid: int in dict.entities:
		var entity_dict: Dictionary = dict.entities[eid]
		_unpack_archives(_w.get_entity(eid), entity_dict["components"])
	
	_w._entity_id = dict["last_entity_id"]
	
	return true
	
func _valid_version(version: StringName) -> bool:
	return true
	
func _unpack_components(e: ECSEntity, dict: Dictionary, class_list: Array[int]) -> void:
	# restore components
	for name: StringName in dict:
		
		# get class index
		var c_dict: Dictionary = dict[name]
		var index: int = c_dict["_class_index"]
		assert(index < class_list.size(), "unpack component fail: class index <%d> is invalid!" % index)
		
		# get class resource
		var CompScript: Resource = load(UIDManager.id_to_text(class_list[index]))
		assert(CompScript != null, "unpack component fail: script <%s> is not exist!" % class_list[index])
		
		# create component
		var c: ECSComponent = CompScript.new()
		e.add_component(name, c)
	
func _unpack_archives(e: ECSEntity, dict: Dictionary) -> void:
	# load components archive
	for name: StringName in dict:
		var c_dict: Dictionary = dict[name]
		var c: ECSComponent = e.get_component(name)
		var input := Serializer.InputArchive.new(c_dict)
		_load_component_archive(c, input)
	
func _load_component_archive(c: ECSComponent, from: Serializer.Archive) -> void:
	# get newest version
	var ar := Serializer.InOutArchive.new({})
	c.pack(ar)
	var newest_version: int = ar.version
	
	# data upgrade
	ar.copy_from(from)
	while ar.version < newest_version:
		c.convert(ar)
		ar.version += 1
		
	# load the newest data
	c.unpack(ar)
	
