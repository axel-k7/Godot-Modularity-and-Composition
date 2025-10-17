extends DecoratorTask
class_name UntilFailure


func run(_delta: float) -> void:
	wrapped_task.tick(_delta)
	match wrapped_task.status:
		Status.RUNNING, Status.SUCCEEDED:
			_running()
		Status.FAILED:
			_fail()
