extends Task
class_name BehaviourTree
##	manages a hierarchy of tasks and a shared or private blackboard

@export var enabled				: bool = true
@export var share_blackboard	: bool = true
@export var root_task			: Task = null

##	initializes blackboard unless subtree
##	auto detects root task if not set in inspector
func _ready() -> void:
	if not _get_parent_tree():
		blackboard = {}
	
	var found_tasks: Array = []
	for child in get_children():
		if child is Task:
			found_tasks.append(child)
	
	if found_tasks.size() > 1:
		push_warning("behaviour tree '%s' has multiple child tasks, using first: '%s'" % [self.name, found_tasks[0].name])
		root_task = found_tasks[0]
	
	assert(root_task != null, "behaviour tree '%s' has no root task" %self.name)
	root_task.tree = self


##	tick is called from an outside source
##	if subtree, called from parent task
func tick(_delta: float) -> void:
	if enabled:
		match status:
			Status.FRESH, Status.RUNNING:
				run(_delta)
			Status.SUCCEEDED, Status.FAILED:
				reset()
				start()

##	run function is delegated to the root task
##	BehaviourTree mirrors root task status
func run(_delta: float) -> void:
	if status == Status.FRESH:
		start()
	root_task.run(_delta)
	status = root_task.status 
	##	^ 
	##	might be redunant because of "child_status()" mirroring
	##	kept for safety

##	see task.gd reset() method 
##	resets private blackboards
func reset() -> void:
	super.reset()
	if not share_blackboard:
		blackboard.clear()


##	see task.gd _copy_to() method
##	copies tree-specific data if given a BehaviourTree
##	root task will be copied and added as a child of the new BehaviourTree
##	will pass a copy of blackboard instead of sharing if the given tree has a private one
func _copy_to(task: Task) -> void:
	super._copy_to(task)
	var bt = task as BehaviourTree
	if bt and root_task:
		bt.root_task = root_task.clone_task()
		bt.add_child(bt.root_task)
		bt.root_task.tree = bt
		
		if share_blackboard:
			bt.blackboard = blackboard #share
		else:
			bt.blackboard = blackboard.duplicate(true) # deep copy


##	loops upward in the hierarchy and returns the first BehaviourTree it finds
func _get_parent_tree() -> BehaviourTree:
	var parent := get_parent()
	while parent and not parent is BehaviourTree:
		parent = parent.get_parent()
	return parent if parent is BehaviourTree else null

##	BehaviourTree mirrors the status of its root task
func child_success() -> void:
	_success()
func child_fail() -> void:
	_fail()
func child_running() -> void:
	_running()
