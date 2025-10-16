extends Node
class_name Task

enum Status {
	FRESH,		#	task not yet run or has been reset
	RUNNING,	#	task not yet completed, needs to run again
	FAILED,		#	task finished unsuccessfully
	SUCCEEDED,	#	task finished successfully
	CANCELLED	#	task terminated by parent/ancestor
}

#	emitted when state is entered
signal task_running(task: Task)
signal task_succeeded(task: Task)
signal task_failed(task: Task)
signal task_cancelled(task: Task)
signal task_reset(task: Task)

#	reference to tree blackboard
var blackboard : Dictionary

#	conditional task that must return true for a task to run (optional)
@export var guard 	: Task	= null
@export var reset_guard_on_fail: bool = true

#	for propogating status and sharing blackboard data
var tree	: BehaviourTree	= null
var control	: Task			= null
var status 	: Status		= Status.FRESH

#	cached sub-tasks
var _subtasks: Array[Task]	= []

#	caches all sub-tasks on initialization
func _ready():
	_update_subtasks()


## Entry / Exit ---------------------------------------------------------------------------------------

#	initializes self and checks guard conditions, fails if guard doesn't succeed
#	runs task-specific "on_start" logic
#	initilizes sub-tasks with proper parent, tree and blackboard references (or private copy)
#	repeats start() call in each sub-task
func start() -> void:
	status = Status.FRESH
	blackboard = tree.blackboard if tree else {}
	
	if guard:
		if guard.status == Status.FRESH:
			guard.start()
		guard.tick(0.0) # <----- ONLY WORKS FOR SIMPLE GUARDS, NEED IMPROVE WITH DELTA
		if guard.status != Status.SUCCEEDED:
			if reset_guard_on_fail:
				guard.reset()
			_fail()
			return
	
	on_start()
	for subtask in _subtasks:
		subtask.control = self
		subtask.tree = self.tree
		
		if subtask is BehaviourTree and not subtask.share_blackboard:
				subtask.blackboard = self.blackboard.duplicate(true)
		else:
			subtask.blackboard = self.blackboard
			
		subtask.start()


#	"on_end" logic can only be called on if task has a finished status
func end() -> void:
	if status in [Status.SUCCEEDED, Status.FAILED, Status.CANCELLED]:
		on_end()
	else: push_warning("task: '%s' called for end() without a finished status" %self.name)


## Update ---------------------------------------------------------------------------------------		

#	tick is called from a parent or controller
#	"run" logic can only be called if task is running
func tick(_delta:float) -> void:
	if status == Status.RUNNING:
		run(_delta)

# executes task-specific logic and calls a status function once
func run(_delta: float) -> void:
	pass

## Status Functions ---------------------------------------------------------------------------------------	

#	sets task status and notifies parent of child status
#	emits signal for potential external listeners
func _running() -> void:
	status = Status.RUNNING
	if control:
		control.subtask_running()
	emit_signal("task_running", self)

#	completes task and does clean up logic
func _complete(state: Status, callback: StringName, signal_name: StringName) -> void:
	status = state
	end()
	if control:
		control.call(callback)
	emit_signal(signal_name, self)

	
func _success() -> void:
	_complete(Status.SUCCEEDED, "subtask_success", "task_succeeded")
func _fail() -> void:
	_complete(Status.FAILED, "subtask_fail", "task_failed")

#	does clean up logic
#	recursively cancels all sub-tasks
func cancel() -> void:
	if status in [Status.RUNNING, Status.FRESH]:
		status = Status.CANCELLED
		end()
		for subtask in _subtasks:
			subtask.cancel()
		if control:
			control.subtask_cancelled()
		emit_signal("task_cancelled", self)

#	extension of cancel which resets task to initial state	
#	recursively resets all sub-tasks
func reset() -> void:
	cancel()
	for subtask in _subtasks:
		subtask.reset()
	status = Status.FRESH
	control = null
	tree = null
	emit_signal("task_reset", self)


## Abstract Hooks ---------------------------------------------------------------------------------------	

#	for task initialization and cleanup
func on_start() -> void:
	pass	
func on_end() -> void:
	pass

#	subtask status callbacks
#	so tasks can react to sub-task events
func subtask_success() -> void:
	pass
func subtask_fail() -> void:
	pass
func subtask_cancelled() -> void:
	pass
func subtask_running() -> void:
	pass


## Copy Functions ---------------------------------------------------------------------------------------	

#	copies properties from this task to another
#	subclasses should override to copy additional properties
func _copy_to(task: Task) -> void:
	task.status = status
	task.control = control
	task.tree = tree
	task.guard = guard

# creates a complete deep copy of self, sub-tasks and guard
func clone_task() -> Task:
	var clone = get_script().new()
	_copy_to(clone)
	for subtask in _subtasks:
		var subtask_clone = subtask.clone_task()
		clone.add_subtask(subtask_clone)
		subtask_clone.control = clone
		subtask_clone.tree = clone.tree
	
	if guard != null:
		clone.guard = guard.clone_task()
	return clone


## Helper Functions ---------------------------------------------------------------------------------------

func _update_subtasks() -> void:
	_subtasks.clear()
	for child in get_children():
		if child is Task:
			_subtasks.append(child)

func add_subtask(subtask: Task) -> void:
	if subtask.get_parent() != self:
		add_child(subtask)
	if subtask not in _subtasks:
		_subtasks.append(subtask)
	
func remove_subtask(subtask: Task) -> void:
	if subtask in _subtasks:
		_subtasks.erase(subtask)
	remove_child(subtask)


##pooling?
