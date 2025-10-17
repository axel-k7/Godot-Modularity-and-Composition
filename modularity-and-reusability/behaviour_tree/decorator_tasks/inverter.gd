extends DecoratorTask
class_name Inverter
#	inverts status of wrapped task

func run(_delta: float) -> void:
	wrapped_task.tick(_delta)
	match wrapped_task.status:
		Status.RUNNING:		_running()
		Status.SUCCEEDED:	_fail()
		Status.FAILED:		_success()
