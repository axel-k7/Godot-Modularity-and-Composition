extends Node
class_name StateMachine

@export var initial_state: 	State			= null
@export var host: 			Character		= null
@export var input_manager: 	InputManager	= null

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.transition.connect(_change_state)
		state_node.host = host
	
	if input_manager:
		for action in input_manager._input_pressed:
			input_manager.connect_signal(action, InputManager.InputTypes.PRESSED, Callable(self, "_on_input"))
		for action in input_manager._input_released:
			input_manager.connect_signal(action, InputManager.InputTypes.RELEASED, Callable(self, "_on_input"))
	
	await owner.ready
	state.enter("")

func _on_input(action: String, event: Variant) -> void:
	state.handle_input(action, event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _change_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": trying to change state to " + target_state_path + " but it does not exist")
		return
	print(get_parent().name, " new state: ", target_state_path)

	var prev_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(prev_state_path, data)
