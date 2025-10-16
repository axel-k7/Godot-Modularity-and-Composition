extends Task
class_name BehaviourTree

@export var enabled				: bool = true
@export var share_blackboard	: bool = true
@export var auto_restart		: bool = true
@export var root_task			: Task = null

#	see task.gd _ready()
#	initializes blackboard unless subtree
#	auto detects root task if not set in inspector
func _ready() -> void:
	super._ready()
	
	if not share_blackboard or not _get_parent_tree():
		blackboard = {}
	
	if _subtasks.is_empty():
		push_warning("behaviour tree '%s' has no sub-tasks -> disabling" % self.name)
		enabled = false
		return
	elif not root_task:
		push_warning("behaviour tree '%s' root task not set -> using '%s'" % [self.name, _subtasks[0].name])
		root_task = _subtasks[0]
	
	if not root_task:
		push_error("behaviour tree '%s' has no root task" %self.name)
	root_task.tree = self


## Update ---------------------------------------------------------------------------------------	

#	overriden task.gd tick() function
#	automatic restart after task finish
func tick(_delta: float) -> void:
	if not enabled:
		return
	match status:
		Status.FRESH, Status.RUNNING:
			run(_delta)
		Status.SUCCEEDED, Status.FAILED:
			if auto_restart:
				reset()
				start()

#	see task.gd run() function
#	run function is delegated to the root task
#	mirrors root task status
func run(_delta: float) -> void:
	if status == Status.FRESH:
		start()
	root_task.tick(_delta)
	#status = root_task.status 
	#	^ 
	#	might be redunant because of subtask callback mirroring


## Status Functions ---------------------------------------------------------------------------------------	

#	see task.gd reset() method 
#	resets private blackboards
func reset() -> void:
	super.reset()
	if not share_blackboard and _get_parent_tree():
		blackboard.clear()


## Abstract Hook Overrides ---------------------------------------------------------------------------------------	

#	BehaviourTree mirrors the status of its root task
func subtask_success() -> void:
	_success()
func subtask_fail() -> void:
	_fail()
func subtask_running() -> void:
	_running()


## Copy Functions ---------------------------------------------------------------------------------------	

#	see task.gd _copy_to() method
#	copies tree-specific data if given a BehaviourTree
#	root task will be copied and added as a child of the new BehaviourTree
#	will pass a copy of blackboard instead of sharing if the given tree has a private one
func _copy_to(task: Task) -> void:
	super._copy_to(task)
	var bt = task as BehaviourTree
	if bt and root_task:
		bt.root_task = root_task.clone_task()
		bt.add_subtask(bt.root_task)
		
		if share_blackboard:
			bt.blackboard = blackboard
		else:
			bt.blackboard = blackboard.duplicate(true)


## Helper Functions ---------------------------------------------------------------------------------------

#	loops upward in the hierarchy and returns the first BehaviourTree it finds
func _get_parent_tree() -> BehaviourTree:
	var parent := get_parent()
	while parent and not (parent is BehaviourTree):
		parent = parent.get_parent()
	return parent if parent is BehaviourTree else null
