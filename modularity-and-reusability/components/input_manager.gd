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
	for i in _input_pressed:
		if event.is_action_pressed(i):
			emit_signal(i+str(InputTypes.PRESSED), [i])
	for i in _input_released:
		if event.is_action_released(i):
			emit_signal(i+str(InputTypes.RELEASED), [i])

func _register_signals(inputs, type):
	for input in inputs:
		if input != "":
			if !has_user_signal(input):
				add_user_signal(input+str(type))

func connect_signal(action: String, type: InputTypes, callable: Callable):
	connect(action + str(type), callable)
