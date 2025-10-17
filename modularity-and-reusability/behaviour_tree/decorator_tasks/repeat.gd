extends DecoratorTask
class_name Repeat

@export var retries: int = 3
var tries: int = 0

func run(_delta: float) -> void:
	wrapped_task.tick(_delta)
	match wrapped_task.status:
		Status.RUNNING:		_running()
		Status.SUCCEEDED:	_success()
		Status.FAILED:
			if tries < retries:
				pass #retry
			else: _fail()
