extends RefCounted
class_name ECSScheduler

var _current_system: StringName
var _system_pool: Dictionary[StringName, ECSParallel]
var _system_graph: Dictionary[StringName, Array]
var _threads_size: int
var _world: ECSWorld

# batch parallel systems
var _batch_systems: Array[Array]
var _systems_completed: _BatchSystemCompleted

func add_systems(systems: Array) -> ECSScheduler:
	for sys: ECSParallel in systems:
		_system_pool[sys.name()] = sys
	for sys: ECSParallel in systems:
		sys.fetch_before_systems(_set_system_before)
		sys.fetch_after_systems(_set_system_after)
		sys._set_world(_world)
	return self
	
func build() -> void:
	pass
	
func run(_delta: float = 0.0) -> void:
	# run the batch of systems
	_run_systems()
	# flush commands
	_flush_commands()
	
## Finish the scheduler
func finish() -> void:
	_world = null
	# stop threads
	# ...
	
func _insert_graph_node(key: StringName, value: StringName) -> void:
	assert(_system_pool.has(value), "Scheduler must have system key [%s]!" % value)
	if not _system_graph.has(key):
		_system_graph[key] = []
	var list := _system_graph[key]
	if value in list:
		return
	list.append(value)
	
func _set_system_before(name: StringName, before_systems: Array) -> void:
	for key: StringName in before_systems:
		_insert_graph_node(name, key)
	
func _set_system_after(name: StringName, after_systems: Array) -> void:
	for key: StringName in after_systems:
		_insert_graph_node(key, name)
	
func _init(world: ECSWorld) -> void:
	_world = world
	
func _set_threads_size(value: int) -> void:
	_threads_size = value
	
func _run_systems() -> void:
	for systems: Array in _batch_systems:
		_post_batch_systems(systems)
		_wait_systems_completed()
	
func _flush_commands() -> void:
	for systems: Array in _batch_systems:
		for sys: ECSParallel in systems:
			sys.commands().flush()
	
func _post_batch_systems(systems: Array) -> void:
	_systems_completed = _BatchSystemCompleted.new(systems)
	
func _wait_systems_completed() -> void:
	while true:
		if _systems_completed.value:
			break
		# work stealing
		# ...
	
# ==============================================================================
class _BatchSystemCompleted extends RefCounted:
	var value: bool:
		set(v):
			pass
		get:
			return _count == _max
	var _mutex := Mutex.new()
	var _count: int = 0
	var _max: int = 0
	func _init(systems: Array) -> void:
		_max = -1 if systems.is_empty() else systems.size()
		for sys: ECSParallel in systems:
			sys.finished = _completed
	func _completed() -> void:
		_mutex.lock()
		_count += 1
		_mutex.unlock()
		
	
