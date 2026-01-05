extends ECSEntity
class_name DebugEntity

# Member variables for debugging
var _components: Dictionary[StringName, ECSComponent]
var _groups: Dictionary[StringName, bool]

func add_component(name: StringName, component := ECSComponent.new()) -> bool:
	_components[name] = component
	return super.add_component(name, component)
	
func remove_component(name: StringName) -> bool:
	_components.erase(name)
	return super.remove_component(name)
	
func remove_all_components() -> bool:
	_components.clear()
	return super.remove_all_components()
	
