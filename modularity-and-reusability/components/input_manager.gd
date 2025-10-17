extends Node
class_name InputManager

enum InputTypes {
	PRESSED,
	RELEASED
}

@export var _input_pressed	: Array[String]
@export var _input_released	: Array[String]

func _ready() -> void:
	_register_signals(_input_pressed, 	InputTypes.PRESSED)
	_register_signals(_input_released, 	InputTypes.RELEASED)

func _unhandled_input(event: InputEvent) -> void:
	for action in InputMap.get_actions():
		if _input_pressed.has(action) and event.is_action_pressed(action):
			emit_signal(action + str(InputTypes.PRESSED), [action], event)
		elif _input_released.has(action) and event.is_action_released(action):
			emit_signal(action + str(InputTypes.RELEASED), [action], event)

func _register_signals(inputs, type):
	for input in inputs:
		if input != "" and InputMap.has_action(input):
			var signal_name = input+str(type)
			if !has_user_signal(signal_name):
				add_user_signal(signal_name)
		elif input != "":
			push_warning("input not in input map: ", input)

func connect_signal(action: String, type: InputTypes, callable: Callable):
	var signal_name = action + str(type)
	if has_user_signal(signal_name):
		var err = connect(action + str(type), callable)
		if err != OK:
			push_error("couldnt connect signal: ", signal_name)
		else:
			push_error("signal does not exist: ", signal_name)
			
