extends Task
class_name Decorator
#	something something wrapped task

@export var wrapped_task: Task = null

#	does not account for switching subtask during runtime
func on_start():
	if _subtasks.size() != 1:
		push_error("'%s' decorator can only have one subtask" % name)
		return
		
	elif not wrapped_task:
		wrapped_task = _subtasks[0]
	wrapped_task.start()
