extends RefCounted
class_name GameEvent

var name: StringName:
	set(v):
		pass
	get:
		return _name
	
var data:
	set(v):
		pass
	get:
		return _data
	
var event_center: GameEventCenter:
	set(v):
		pass
	get:
		return _event_center.get_ref()

# ==============================================================================
# private
var _name: StringName
var _data: Variant
var _event_center: WeakRef
	
func _init(n: StringName, d: Variant) -> void:
	_name = n
	_data = d
	
func _to_string() -> String:
	return "GameEvent(\"%s\", %s)" % [_name, _data]
	
