extends RefCounted

class Operation extends RefCounted:
	func execute() -> void:
		pass
	
var _operations: Array[Operation]

func flush() -> void:
	for op in _operations:
		op.execute()
	_operations.clear()
	
