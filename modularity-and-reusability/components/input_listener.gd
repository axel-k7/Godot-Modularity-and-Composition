extends Node
class_name InputListener

@export var listened_actions: Array[String]
@onready var input_manager: InputManager = GlobalInputManager

signal action_triggered(action_name: String, pressed: bool)

func _ready() -> void:
	if not input_manager:
		push_error("input listener has no manager %s", % self.name)
		return

	input_manager.register_listener(self, listened_actions)

func _on_action_event(action_name: String, pressed: bool) -> void:
	print("%s received %s %s" % [get_parent().name, action_name, "pressed" if pressed else "released"])
	action_triggered.emit(action_name, pressed)

func _exit_tree() -> void:
	if input_manager:
		input_manager.unregister_listener(self)
