extends Character
class_name Player

@export var input_listener: InputListener

func _ready() -> void:
	input_listener.action_triggered.connect(self._on_action_triggered)

func _on_action_triggered(action_name: String, pressed: bool):
	match action_name:
		"gameplay_jump":
			if pressed:
				movement_component.set_intent(Vector3(0,1,0))
		"gameplay_forward":
			if pressed:
				movement_component.set_intent(Vector3(0,0,-1))
			else:
				movement_component.set_intent(Vector3(0,0,0))
