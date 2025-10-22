extends Node
class_name InputManager

signal mouse_moved(position: Vector2)
signal mouse_wheel(delta: Vector2)

var listeners: Dictionary = {}

@export var gsm: GameStateManager = GlobalGameStateManager
var current_context: String = ""
var enabled: bool = true
var mouse_enabled: bool = true

var action_states: Dictionary = {}

func _ready():
	_initialize_actions()

func _initialize_actions():
	action_states.clear()
	for action in InputMap.get_actions():
		action_states[action] = false

func register_listener(listener: Node, actions: Array[String]) -> void:
	for action in actions:
		if not listeners.has(action):
			listeners[action] = []
		if listener not in listeners[action]:
			listeners[action].append(listener)

func unregister_listener(listener: Node) -> void:
	for key in listeners.keys():
		listeners[key].erase(listener)

func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	if event is InputEventMouseMotion and mouse_enabled:
		mouse_moved.emit(event.position)
	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP:
			mouse_wheel.emit(Vector2(0, 1))
		elif event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN:
			mouse_wheel.emit(Vector2(0, -1))

func _process(_delta: float) -> void:
	if not enabled:
		return

	for action in InputMap.get_actions():
		if not _action_allowed_in_context(action):
			continue

		var pressed: bool = Input.is_action_pressed(action)
		if not action_states.has(action):
			action_states[action] = false
		var prev_pressed: bool = action_states[action]
		var axis_value: float = Input.get_action_strength(action)

		if pressed and not prev_pressed:
			_notify_listeners(action, true)
		elif not pressed and prev_pressed:
			_notify_listeners(action, false)

		action_states[action] = pressed

func _notify_listeners(action_name: String, pressed: bool) -> void:
	if not listeners.has(action_name):
		return
	for listener in listeners[action_name]:
		if listener:
			listener._on_action_event(action_name, pressed)

func _action_allowed_in_context(action_name: String) -> bool:
	return action_name.begins_with(current_context + "_") or action_name.begins_with("global_")
