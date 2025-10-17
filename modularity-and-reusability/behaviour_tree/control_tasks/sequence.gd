extends ControlTask
class_name Sequence
#	returns success if all subtasks are successful

func run(_delta: float) -> void:
	if subtask_index >= _subtasks.size():
		_success()
		return
	
	var current_task = _subtasks[subtask_index]
	current_task.tick(_delta)
	
	match current_task.Status:
		Status.RUNNING:
			_running()
		Status.SUCCEEDED:
			subtask_index += 1
			if subtask_index >= _subtasks.size():
				_success()
			else:
				_subtasks[subtask_index].start()
		Status.FAILED:
			_fail()
