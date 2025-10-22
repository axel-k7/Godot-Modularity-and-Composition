extends Character
class_name Player

@export var input_listener: InputListener

func _ready() -> void:
	input_listener.action_triggered.connect(self._on_action_triggered)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_action_triggered(action_name: String, pressed: bool):
	match action_name:
		"gameplay_jump":
			if pressed:
				movement_component.jump()
		"gameplay_forward":
			if pressed:
				pass
