extends GroundMovementComponent

func jump():
	velocity_component.apply_impulse(Vector3(0,6,0))
