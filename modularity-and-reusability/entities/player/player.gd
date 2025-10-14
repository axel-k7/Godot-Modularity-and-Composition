extends CharacterBody3D
class_name Player

@export var _input_manager: InputManager
@export var _movement_component: MovementComponent

func _ready() -> void:
	var _callable = Callable(_movement_component, "_jump")
	_input_manager.connect_signal("jump", InputManager.InputTypes.PRESSED, _callable)
	_callable = Callable(_movement_component, "_fall")
	_input_manager.connect_signal("jump", InputManager.InputTypes.RELEASED, _callable)

func _physics_process(delta: float) -> void:
	move_and_slide()
