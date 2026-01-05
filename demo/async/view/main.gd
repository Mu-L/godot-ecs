extends Node2D

var _world := ECSWorld.new("AsyncDemo")

class InputSystem extends ECSAsyncSystem:
	pass
	
class RenderSystem extends ECSAsyncSystem:
	# override
	func _list_components() -> Dictionary[StringName, int]:
		return {
			&"my_component": READ_ONLY,
			&"other_component": READ_WRITE,
		}
	# override
	func _view_components(_view: Dictionary) -> void:
		pass
	
func _ready() -> void:
	_world.scheduler().add_systems([
		InputSystem.new(&"input_system", self).before([&"render_system"]),
		RenderSystem.new(&"render_system", self).after([&"input_system"]),
	]).run()
	
