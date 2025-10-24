extends MovementComponent
class_name AerialMovementComponent

@export var acceleration: float = 6.0
@export var drag: float = 1.0

func _physics_process(_delta: float) -> void:
	var applied_accel = intent_direction * acceleration
	velocity_component.apply_acceleration("flight", applied_accel)
	
	var drag_force = -velocity_component.get_velocity() * drag
	velocity_component.apply_acceleration("drag", drag_force)
