extends Control

@onready var _rich_text_label: RichTextLabel = $CenterContainer2/RichTextLabel

func _on_sync_demo_mouse_entered() -> void:
	_rich_text_label.text = "[center]%s[/center]" % """
This is a fundamental demonstration of an ECS framework, showcasing core operations in a single-threaded environment. The example creates an ECS world, defines components and systems, and updates all systems each frame in the order they were registered, all within the main thread. Through simple entity creation, component manipulation, and system execution flow, it intuitively presents the basic working model of the ECS architecture. It is well-suited for beginners to understand and learn the core concepts of ECS.
	"""
	
func _on_a_sync_demo_mouse_entered() -> void:
	_rich_text_label.text = "[center]%s[/center]" % """
This is an advanced demonstration of a parallel ECS framework, illustrating how to use a scheduler to enable asynchronous system execution. The example builds a multi-threaded system scheduling mechanism that significantly improves performance for large-scale entity processing through automatic dependency analysis and task parallelization. It demonstrates key techniques such as read/write access control, data chunking, and load balancing, making it ideal for complex games or simulation scenarios requiring high-performance computing.
	"""
	
func _on_sync_demo_pressed() -> void:
	get_tree().change_scene_to_packed(preload("uid://djskl147q3osk"))
	
func _on_a_sync_demo_pressed() -> void:
	get_tree().change_scene_to_packed(preload("uid://c3u7n5w6o0k02"))
	
