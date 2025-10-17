extends DecoratorTask
class_name Repeat

@export var retries: int = 3
var attempts: int = 0

func run(delta: float) -> void:
	wrapped_task.tick(delta)
	match wrapped_task.status:
		Status.RUNNING:		_running()
		Status.SUCCEEDED:	_success()
		Status.FAILED:
			attempts += 1
			if attempts < retries:
				wrapped_task.reset()
				_running()
			else: _fail()
