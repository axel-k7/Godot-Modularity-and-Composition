extends Character

@export var behaviour_tree: BehaviourTree

func _process(delta):
	behaviour_tree.tick(delta)

func _physics_process(_delta):
	move_and_slide()
