extends ControlTask
class_name Selector
#	returns success if any subtask is successful

func run(_delta: float) -> void:
	if subtask_index >= _subtasks.size():
		_fail()
		return

	var current_task = _subtasks[subtask_index]
	current_task.tick(_delta)

	match current_task.status:
		Status.RUNNING:
			_running()
		Status.SUCCEEDED:
			_success()
		Status.FAILED:
			subtask_index += 1
			if subtask_index >= _subtasks.size():
				_fail()
			else:
				_subtasks[subtask_index].start()
