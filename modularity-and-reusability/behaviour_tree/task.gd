extends Node
class_name Task


enum Status {
	FRESH,		#task not yet run / reset
	RUNNING,	#task not yet completed, needs to run again
	FAILED,		#task completed: failure
	SUCCEEDED,	#task completed: success
	CANCELLED	#task terminated by ancestor
}

#emitted during given state
signal task_running(task: Task)
signal task_succeeded(task: Task)
signal task_failed(task: Task)
signal task_cancelled(task: Task)
signal task_reset(task: Task)

#reference to tree blackboard
var blackboard : Dictionary

#conditional task that must return true for this task to run (optional)
@export var guard 	: Task	= null

var tree	: BehaviourTree	= null
var control	: Task			= null
var status 	: Status		= Status.FRESH

##entry / exit

func start() -> void:
	status = Status.FRESH
	blackboard = tree.blackboard if tree else {}
	on_start()
	for child in get_children():
		if child is Task:
			child.control = self
			child.tree = self.tree
			
			if child is BehaviourTree:
				if child.share_blackboard:
					child.blackboard = self.blackboard
				else:
					child.blackboard = self.blackboard.duplicate(true)
			else:
				child.blackboard = self.blackboard
				
			child.start()

func end() -> void:
	if status in [Status.SUCCEEDED, Status.FAILED, Status.CANCELLED]:
		on_end()			
			

##update

func _tick(_delta:float) -> void:
	if status == Status.RUNNING:
		run(_delta)

#executes task logic and calls status function once
func run(_delta: float) -> void:
	if guard:
		if guard.status != Status.FRESH:
			guard.start()
		guard.run(_delta)
		if guard.status != Status.SUCCEEDED:
			guard.reset()
			_fail()
			return
	#task logic


## abstract functions

func on_start() -> void:
	pass
func on_end() -> void:
	pass
func child_success() -> void:
	pass
func child_fail() -> void:
	pass
func child_cancelled() -> void:
	pass
func child_running() -> void:
	pass


## status functions

func _running() -> void:
	status = Status.RUNNING
	if control:
		control.child_running()
	emit_signal("task_running", self)

func _success() -> void:
	status = Status.SUCCEEDED
	end()
	if control:
		control.child_success()
	emit_signal("task_succeeded", self)

func _fail() -> void:
	status = Status.FAILED
	end()
	if control:
		control.child_fail()
	emit_signal("task_failed", self)

func _cancel() -> void:
	if status == Status.RUNNING:
		status = Status.CANCELLED
		end()
		for child in get_children():
			if child is Task:
				child.cancel()
		if control:
			control.child_cancelled()
		emit_signal("task_cancelled", self)
		
func reset() -> void:
	_cancel()
	status = Status.FRESH
	control = null
	tree = null
	for child in get_children():
		if child is Task:
			child.reset()
	emit_signal("task_reset", self)


## copy functions

func _copy_to(task: Task) -> void:
	task.status = status
	task.control = control
	task.tree = tree
	task.guard = guard
	#subclasses should override to copy additional properties

func clone_task() -> Task:
	var clone = get_script().new()
	_copy_to(clone)
	for child in get_children():
		if child is Task:
			var child_clone = child._clone_task()
			clone.add_child(child_clone)
			child_clone.control = clone
			child_clone.tree = clone.tree
	
	if guard != null:
		clone.guard = guard._clone_task()
	return clone
	
	
	
	
##USE LATER
#var _task_children: Array[Task] = []
#func _update_task_children() -> void:
#	_task_children.clear()
#	for child in get_children():
#		if child is Task:
#			_task_children.append(child)

#func _pool_reset() -> void:
#override in subclasses to reset task-specific data
#might implement later
