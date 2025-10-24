extends MovementComponent
class_name GroundMovementComponent

@export var acceleration: float = 10.0
@export var deceleration: float = 20.0

func _physics_process(delta: float) -> void:
	var applied_accel = Vector3.ZERO
	if intent_direction != Vector3.ZERO:
		applied_accel = intent_direction * acceleration
		
	if applied_accel.length() > 0:
		velocity_component.apply_acceleration("movement", applied_accel)
	else:
		velocity_component.remove_acceleration("movement")
	
	
	var current_velocity = velocity_component.get_velocity()
	if current_velocity.length() > 0:
		var vel_dir = current_velocity.normalized()
		var input_dir = intent_direction	
		
		if input_dir.length() == 0 or vel_dir.dot(input_dir) <= 0:
			var friction_strength = deceleration * delta
			var target_velocity = current_velocity.move_toward(Vector3.ZERO, friction_strength)
			var friction_force = (target_velocity - current_velocity).project(vel_dir) / delta
			velocity_component.apply_acceleration("friction", friction_force)
		else:
			velocity_component.remove_acceleration("friction")
