extends ECSComponent
class_name ECSDataComponent

var data: Variant

signal on_data_changed(sender: ECSDataComponent, data)

func _init(v: Variant) -> void:
	data = v
	
func set_data(v: Variant) -> void:
	data = v
	on_data_changed.emit(self, data)
	
# override
func _on_pack(ar: Archive) -> void:
	ar.set_var("data", data)
	
# override
func _on_unpack(ar: Archive) -> void:
	data = ar.get_var("data")
	
