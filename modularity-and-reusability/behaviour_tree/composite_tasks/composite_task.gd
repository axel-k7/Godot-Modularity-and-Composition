extends Task
class_name CompositeTask

var subtask_index: int = 0

func on_start() -> void:
	subtask_index = 0
	if _subtasks.is_empty():
		push_warning("'%s' composite has no subtasks" % name)
		_fail()
		return
	
	_subtasks[subtask_index].start()

func on_end() -> void:
	subtask_index = 0
