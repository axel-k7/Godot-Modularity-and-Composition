extends Character
class_name Player

@export var input_manager: InputManager

func _ready() -> void:
	var _callable = Callable(self, "_jump")
	#input_manager.connect_signal("jump", InputManager.InputTypes.PRESSED, _callable)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _jump():
	print("a")
