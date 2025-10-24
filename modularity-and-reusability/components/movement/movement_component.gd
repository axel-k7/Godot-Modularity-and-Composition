@abstract extends Node
class_name MovementComponent

@export var velocity_component: VelocityComponent

var intent_direction: Vector3 = Vector3.ZERO

func _ready():
	if not velocity_component:
		push_error("movement component has no velocity component")

func set_intent(direction: Vector3) -> void:
	intent_direction = direction.normalized()

@abstract func _physics_process(delta: float) -> void
