extends DecoratorTask
class_name ForceSuccess

func run(_delta: float) -> void:
	wrapped_task.tick(_delta)
	match wrapped_task.status:
		Status.RUNNING:
			_running()
		Status.SUCCEEDED, Status.FAILED: 
			_success()
